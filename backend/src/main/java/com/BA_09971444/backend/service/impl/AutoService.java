package com.BA_09971444.backend.service.impl;

import com.BA_09971444.backend.exception.InvalidDateException;
import com.BA_09971444.backend.exception.WRFBuildFailedException;
import com.BA_09971444.backend.service.GfsService;
import com.BA_09971444.backend.service.IconService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class AutoService implements ApplicationRunner {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final GfsService gfsService;
    private final IconService iconService;

    public AutoService(GfsService gfsService, IconService iconService) {
        this.gfsService = gfsService;
        this.iconService = iconService;
    }

    /**
     * Downloads Gfs and Icon data, runs WRF and Visualisation for the current day upon starting the application.
     */
    @Override
    public void run(ApplicationArguments args) {
        LOGGER.debug("Automatic run after starting backend.");

        ExecutorService executorService = Executors.newFixedThreadPool(2);
        List<Callable<Integer>> firstRun = new ArrayList<>();
        List<Callable<Integer>> secondRun = new ArrayList<>();

        Callable<Integer> gfs_1 = () -> {
            downloadData("gfs");
            runWRF("gfs");
            return 1;
        };
        Callable<Integer> icon_1 = () -> {
            downloadData("icon");
            return 2;
        };

        Callable<Integer> gfs_2 = () -> {
            runPostScript("gfs");
            return 1;
        };
        Callable<Integer> icon_2 = () -> {
            runWRF("icon");
            runPostScript("icon");
            return 2;
        };

        if (!gfsService.existsGFSByStartEquals(LocalDate.now())) {
            firstRun.add(gfs_1);
            secondRun.add(gfs_2);
        }
        if (!iconService.existsICONByStartEquals(LocalDate.now())) {
            firstRun.add(icon_1);
            secondRun.add(icon_2);
        }
        if (!secondRun.isEmpty()) {
            try {
                executorService.invokeAll(firstRun);
                executorService.invokeAll(secondRun);
                gfsService.saveGFSImages(LocalDate.now());
                iconService.saveICONImages(LocalDate.now());
            } catch (WRFBuildFailedException | InterruptedException e) {
                LOGGER.error(e.getMessage());
            }
            executorService.shutdown();
        }
    }

    /**
     * Runs bash script to download Data.
     *
     * @param type of model to download
     */
    private void downloadData(String type) {
        LOGGER.debug("Downloading {} Data.", type.toUpperCase());

        String[] command = new String[]{getScriptDirectory() + "/" + type.toLowerCase() + "_download.sh",
                String.valueOf(LocalDate.now().getDayOfMonth()), String.valueOf(LocalDate.now().getMonthValue()),
                String.valueOf(LocalDate.now().getYear())};
        try {
            runProcess(command, true, type + "_download");
        } catch (WRFBuildFailedException | InvalidDateException e) {
            throw new WRFBuildFailedException("Downloading " + type.toUpperCase() + " Data failed. " + e.getMessage());
        }
    }

    /**
     * Runs main.sh.
     * Runs geogrid if necessary.
     * Executes ungrib, metgrid and WPS.
     * Computes WRF output.
     *
     * @param type of model to download
     */
    private void runWRF(String type) {
        LOGGER.debug("Running WPS and WRF for {}.", type.toUpperCase());

        // Creates processBuilder to run script
        String[] command = new String[]{getScriptDirectory() + "/main.sh", type.toUpperCase(),
                String.valueOf(LocalDate.now().getDayOfMonth()), String.valueOf(LocalDate.now().getMonthValue()),
                String.valueOf(LocalDate.now().getYear())};
        try {
            runProcess(command, false, type + "_main");
        } catch (WRFBuildFailedException e) {
            throw new WRFBuildFailedException("Running the main script failed." + e.getMessage());
        }
    }

    /**
     * Runs ARWpost and GrADS to visualize the WRF output.
     *
     * @param type of model to download
     */
    private void runPostScript(String type) {
        LOGGER.debug("Running post processing for {}.", type.toUpperCase());

        // Creates processBuilder to run script
        String[] command_grads = new String[]{getScriptDirectory() + "/runGrADs.sh", type.toUpperCase(),
                String.valueOf(LocalDate.now().getDayOfMonth()), String.valueOf(LocalDate.now().getMonthValue()),
                String.valueOf(LocalDate.now().getYear())};

        String[] command_ncl = new String[]{getScriptDirectory() + "/runNCL.sh", type.toUpperCase(),
                String.valueOf(LocalDate.now().getDayOfMonth()), String.valueOf(LocalDate.now().getMonthValue()),
                String.valueOf(LocalDate.now().getYear())};
        try {
            runProcess(command_grads, false, type + "_runGrADs");
            runProcess(command_ncl, false, type + "_runNCL");

        } catch (WRFBuildFailedException e) {
            LOGGER.error("Running the post script failed." + e.getMessage());
        }
    }

    /**
     * Creates new process to run a bash script.
     *
     * @param command    to run right script.
     * @param isDownload true = script is used to download online data, false = script is used to run program.
     */
    private void runProcess(String[] command, boolean isDownload, String log) {
        LOGGER.debug("Run Process with command: {}.", command[0]);

        ProcessBuilder processBuilder = new ProcessBuilder(command);
        try {
            Process process = processBuilder
                    .redirectOutput(new File("log", log + "_output.txt"))
                    .redirectError(new File("log", log + "_error.txt"))
                    .start();

            int exitCode = process.waitFor();

            if (exitCode != 0 && isDownload) throw new InvalidDateException("Invalid date given.");
            LOGGER.info("Finished Process with command: {}.", command[0]);
        } catch (IOException | InterruptedException e) {
            throw new WRFBuildFailedException(e.getMessage());
        }
    }

    /**
     * Finds correct path to the scripts' directory.
     *
     * @return path to the right directory.
     */
    private Path getScriptDirectory() {
        LOGGER.debug("Get path to the script directory.");

        Path root = Paths.get(System.getProperty("user.dir")).getParent();
        Path wrfPath = Paths.get(root + "/WRF/scripts");
        if (!Files.exists(wrfPath)) throw new WRFBuildFailedException("Path does not exist: " + wrfPath);
        return wrfPath;
    }
}

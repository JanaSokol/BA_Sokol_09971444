package com.BA_09971444.backend.service.Impl;

import com.BA_09971444.backend.entity.GFS;
import com.BA_09971444.backend.entity.GFSImage;
import com.BA_09971444.backend.entity.ICON;
import com.BA_09971444.backend.entity.ICONImage;
import com.BA_09971444.backend.exception.InvalidDateException;
import com.BA_09971444.backend.exception.WRFBuildFailedException;
import com.BA_09971444.backend.repository.GFSImageRepository;
import com.BA_09971444.backend.repository.GFSRepository;
import com.BA_09971444.backend.repository.ICONImageRepository;
import com.BA_09971444.backend.repository.ICONRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class ServiceImpl implements com.BA_09971444.backend.service.Impl.Service, ApplicationRunner {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final GFSImageRepository gfsImageRepository;
    private final GFSRepository gfsRepository;
    private final ICONRepository iconRepository;
    private final ICONImageRepository iconImageRepository;
    private final Integer amountOfImages = 11;

    public ServiceImpl(GFSImageRepository gfsImageRepository, GFSRepository gfsRepository, ICONRepository iconRepository, ICONImageRepository iconImageRepository) {
        this.gfsImageRepository = gfsImageRepository;
        this.gfsRepository = gfsRepository;
        this.iconRepository = iconRepository;
        this.iconImageRepository = iconImageRepository;
    }

    /**
     * Downloads GFS and Icon data, runs WRF and Visualisation for the current day upon starting the application.
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

        if (!gfsRepository.existsGFSByStartEquals(LocalDate.now())) {
            firstRun.add(gfs_1);
            secondRun.add(gfs_2);
        }
        if (!iconRepository.existsICONByStartEquals(LocalDate.now())) {
            firstRun.add(icon_1);
            secondRun.add(icon_2);
        }
        if (!firstRun.isEmpty()) {
            try {
                executorService.invokeAll(firstRun);
                executorService.invokeAll(secondRun);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            executorService.shutdown();
        }
    }

    @Transactional
    @Override
    public GFS getGFSOutputByDate(GFS gfs) {
        LOGGER.debug("Get GFS Output {}", gfs);
        return null;

    }

    /**
     * Runs bash script to download Data.
     *
     * @param type of model to download
     */
    private void downloadData(String type) {
        LOGGER.debug("Downloading {} Data.", type);

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
        LOGGER.debug("Running WPS and WRF for {}.", type);

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
    @Transactional
    void runPostScript(String type) {
        LOGGER.debug("Running post processing for {}.", type);

        // Creates processBuilder to run script
        String[] command = new String[]{getScriptDirectory() + "/runPost.sh", type.toUpperCase(),
                String.valueOf(LocalDate.now().getDayOfMonth()), String.valueOf(LocalDate.now().getMonthValue()),
                String.valueOf(LocalDate.now().getYear())};
        try {
            runProcess(command, false, type + "_runPost");

            switch (type) {
                case "gfs":
                    saveGFSImages();
                    break;
                case "icon":
                    saveICONImages();
                    break;
            }


        } catch (WRFBuildFailedException | IOException e) {
            System.out.println(e.getMessage());
            throw new WRFBuildFailedException("Running the post script failed." + e.getMessage());
        }
    }

    private void saveGFSImages() throws IOException {
        LOGGER.debug("Saving GFS Images.");

        Set<GFSImage> gfsImages = new HashSet<>();

        for (int i = 1; i <= amountOfImages; i++) {
            ClassPathResource backImgFile = new ClassPathResource("GFS_IMAGES/GFS_" + i + ".png");
            byte[] arrayPic = new byte[(int) backImgFile.contentLength()];
            backImgFile.getInputStream().read(arrayPic);
            GFSImage gfsImage = GFSImage.GFSImageBuilder.aGFSImage()
                    .withImage(arrayPic)
                    .build();
            gfsImages.add(gfsImage);
            gfsImageRepository.save(gfsImage);
        }
        GFS gfs = GFS.GFSBuilder.aGFS()
                .withStart(LocalDate.now())
                .withImages(gfsImages)
                .build();
        gfsRepository.save(gfs);

    }

    private void saveICONImages() throws IOException {
        LOGGER.debug("Saving ICON Images.");

        Set<ICONImage> iconImages = new HashSet<>();

        for (int i = 1; i <= amountOfImages; i++) {
            ClassPathResource backImgFile = new ClassPathResource("ICON_IMAGES/ICON_" + i + ".png");
            byte[] arrayPic = new byte[(int) backImgFile.contentLength()];
            backImgFile.getInputStream().read(arrayPic);
            ICONImage iconImage = ICONImage.ICONImageBuilder.aICONImage()
                    .withImage(arrayPic)
                    .build();
            iconImages.add(iconImage);
            iconImageRepository.save(iconImage);
        }
        ICON icon = ICON.ICONBuilder.anICON()
                .withStart(LocalDate.now())
                .withImages(iconImages)
                .build();
        iconRepository.save(icon);
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

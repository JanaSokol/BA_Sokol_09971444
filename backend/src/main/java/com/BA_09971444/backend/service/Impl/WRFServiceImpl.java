package com.BA_09971444.backend.service.Impl;

import com.BA_09971444.backend.exception.WRFBuildFailedException;
import com.BA_09971444.backend.service.WRFService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.invoke.MethodHandles;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class WRFServiceImpl implements WRFService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    public WRFServiceImpl() {

    }

    @Override
    public void getWRFOutputByDate(int day, int month, int year, int cycle) {
        LOGGER.debug("Get WRF Output by date: {}.{}.{} and cycle {}", day, month, year, cycle);

        // Run main script
        runMainScript(day, month, year, cycle);
    }

    /**
     * Runs main.sh.
     * Runs geogrid if necessary.
     * Executes ungrib, metgrid and WPS.
     * Computes WRF output.
     *
     * @param day   of file to download.
     * @param month of file to download.
     * @param year  of file to download.
     * @param cycle of file to download.
     */
    private void runMainScript(int day, int month, int year, int cycle) {
        LOGGER.debug("Run main.sh script");

        // Download data
        //downloadGFSData(day, month, year, cycle);

        // Creates processBuilder to run script
        String[] command = new String[]{getScriptDirectory() + "/main.sh", String.valueOf(day), String.valueOf(month), String.valueOf(year), (cycle > 9 ? String.valueOf(cycle) : "0" + cycle)};
        try {
            runProcess(command, false);
        } catch (WRFBuildFailedException e) {
            throw new WRFBuildFailedException("Running the main script failed." + e.getMessage());
        }
    }

    /**
     * Runs bash script to download GFS Data.
     *
     * @param day   of file to download.
     * @param month of file to download.
     * @param year  of file to download.
     * @param cycle of file to download.
     */
    private void downloadGFSData(int day, int month, int year, int cycle) {
        LOGGER.debug("Download GFS Data with date: {}.{}.{} and cycle {}", day, month, year, cycle);

        String[] command = new String[]{getScriptDirectory() + "/download_gfs.sh", String.valueOf(day), String.valueOf(month), String.valueOf(year), (cycle > 9 ? String.valueOf(cycle) : "0" + cycle)};
        try {
            runProcess(command, true);
        } catch (WRFBuildFailedException e) {
            throw new WRFBuildFailedException("Downloading GFS Data failed. " + e.getMessage());
        }
    }

    /**
     * Creates new process to run a bash script.
     *
     * @param command    to run right script.
     * @param isDownload true = script is used to download online data, false = script is used to run program.
     */
    private void runProcess(String[] command, boolean isDownload) {
        if (isDownload) {
            LOGGER.debug("Run Process with command: {} for the date: {}.{}.{} and cycle {}", command[0], command[3], command[2], command[1], command[4]);
        } else {
            LOGGER.debug("Run Process with command: {}", command[0]);
        }

        ProcessBuilder processBuilder = new ProcessBuilder(command);
        try {
            Process process = processBuilder.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(isDownload ? process.getErrorStream() : process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                LOGGER.info(line);
            }
        } catch (IOException e) {
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

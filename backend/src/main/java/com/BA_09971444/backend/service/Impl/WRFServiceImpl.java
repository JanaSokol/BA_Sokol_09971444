package com.BA_09971444.backend.service.Impl;

import com.BA_09971444.backend.entity.GFS;
import com.BA_09971444.backend.entity.GFSImage;
import com.BA_09971444.backend.exception.InvalidDateException;
import com.BA_09971444.backend.exception.WRFBuildFailedException;
import com.BA_09971444.backend.repository.GFSImageRepository;
import com.BA_09971444.backend.repository.GFSRepository;
import com.BA_09971444.backend.service.WRFService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.invoke.MethodHandles;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Service
public class WRFServiceImpl implements WRFService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final GFSImageRepository gfsImageRepository;
    private final GFSRepository gfsRepository;

    public WRFServiceImpl(GFSImageRepository gfsImageRepository, GFSRepository gfsRepository) {
        this.gfsImageRepository = gfsImageRepository;
        this.gfsRepository = gfsRepository;
    }

    @Transactional
    @Override
    public GFS getGFSOutputByDate(GFS gfs) {
        LOGGER.debug("Get GFS Output {}", gfs);

        // Download data
        downloadGFSData(gfs.getStart(), gfs.getCycle());
        // Run WPS and WRF
        runWRF(gfs.getStart(), gfs.getCycle());
        // Run Post Processing
        return runPostScript(gfs);

    }

    /**
     * Runs bash script to download GFS Data.
     *
     * @param date  date of file to download.
     * @param cycle of file to download.
     */
    private void downloadGFSData(LocalDate date, Long cycle) {
        LOGGER.debug("Download GFS Data with date: {} and cycle: {}", date, cycle);

        String[] command = new String[]{getScriptDirectory() + "/download_gfs.sh", String.valueOf(date.getDayOfMonth()), String.valueOf(date.getMonthValue()), String.valueOf(date.getYear()), (cycle > 9 ? String.valueOf(cycle) : "0" + cycle)};
        try {
            runProcess(command, true);
        } catch (WRFBuildFailedException | InvalidDateException e) {
            throw new WRFBuildFailedException("Downloading GFS Data failed. " + e.getMessage());
        }
    }

    /**
     * Runs main.sh.
     * Runs geogrid if necessary.
     * Executes ungrib, metgrid and WPS.
     * Computes WRF output.
     *
     * @param start date of file to download.
     * @param cycle of file to download.
     */
    private void runWRF(LocalDate start, Long cycle) {
        LOGGER.debug("Runs WPS and WRF");

        // Creates processBuilder to run script
        String[] command = new String[]{getScriptDirectory() + "/main.sh", String.valueOf(start.getDayOfMonth()), String.valueOf(start.getMonthValue()), String.valueOf(start.getYear()), (cycle > 9 ? String.valueOf(cycle) : "0" + cycle)};
        try {
            runProcess(command, false);
        } catch (WRFBuildFailedException e) {
            throw new WRFBuildFailedException("Running the main script failed." + e.getMessage());
        }
    }


    /**
     * Runs ARWpost and GrADS to visualize the WRF output.
     *
     * @param gfs to create
     * @return created gfs
     */
    private GFS runPostScript(GFS gfs) {
        LOGGER.debug("Run Post Processing");

        // Creates processBuilder to run script
        String[] command = new String[]{getScriptDirectory() + "/runPost.sh", String.valueOf(gfs.getStart().getDayOfMonth()), String.valueOf(gfs.getStart().getMonthValue()), String.valueOf(gfs.getStart().getYear()), (gfs.getCycle() > 9 ? String.valueOf(gfs.getCycle()) : "0" + gfs.getCycle())};
        try {
            runProcess(command, false);

            Set<GFSImage> gfsImages = new HashSet<>();

            for (int i = 0; i < 1; i++) {
                ClassPathResource backImgFile = new ClassPathResource("gfs_images/" + i + ".png");
                byte[] arrayPic = new byte[(int) backImgFile.contentLength()];
                backImgFile.getInputStream().read(arrayPic);

                GFSImage gfsImage = GFSImage.GFSImageBuilder.aGFSImage()
                        .withImage(arrayPic)
                        .build();

                gfsImages.add(gfsImage);
                gfsImageRepository.save(gfsImage);
            }
            gfs.setImages(gfsImages);
            return gfsRepository.save(gfs);


        } catch (WRFBuildFailedException | IOException e) {
            throw new WRFBuildFailedException("Running the main script failed." + e.getMessage());
        }
    }

    /**
     * Creates new process to run a bash script.
     *
     * @param command    to run right script.
     * @param isDownload true = script is used to download online data, false = script is used to run program.
     */
    private void runProcess(String[] command, boolean isDownload) {
        LOGGER.debug("Run Process with command: {} for the date: {}.{}.{} and cycle {}", command[0], command[3], command[2], command[1], command[4]);

        ProcessBuilder processBuilder = new ProcessBuilder(command);
        try {
            Process process = processBuilder.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(isDownload ? process.getErrorStream() : process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                LOGGER.info(line);
            }

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

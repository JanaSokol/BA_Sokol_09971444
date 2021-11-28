package com.BA_09971444.backend.service.impl;

import com.BA_09971444.backend.entity.Gfs;
import com.BA_09971444.backend.entity.GfsImage;
import com.BA_09971444.backend.exception.NotFoundException;
import com.BA_09971444.backend.repository.GfsImageRepository;
import com.BA_09971444.backend.repository.GfsRepository;
import com.BA_09971444.backend.service.GfsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class GfsServiceImpl implements GfsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final GfsImageRepository gfsImageRepository;
    private final GfsRepository gfsRepository;

    public GfsServiceImpl(GfsImageRepository gfsImageRepository, GfsRepository gfsRepository) {
        this.gfsImageRepository = gfsImageRepository;
        this.gfsRepository = gfsRepository;
    }

    @Override
    public List<GfsImage> getGFSOutputByDate(LocalDate date, Long visType) {
        LOGGER.debug("Get Gfs Output by date {}", date);

        try {
            return (visType == 1) ? gfsRepository.getGradsImages(date) : gfsRepository.getNclImages(date);
        } catch (DataAccessException e) {
            throw new NotFoundException(String.format("Could not find gfs with date %s", date));
        }
    }

    @Transactional
    @Override
    public void saveGFSImages(LocalDate date) {
        LOGGER.debug("Saving Gfs Images.");

        Set<GfsImage> gradsImages = new HashSet<>();
        Set<GfsImage> nclImages = new HashSet<>();
        try {
            int amountOfImages = 11;
            int cycle = 0;
            int timeStep = 12;

            for (int i = 0; i < amountOfImages; i++) {
                gradsImages.add(saveIndividualImage(date, cycle, "GFS_IMAGES/GFS_GrADs_" + (i + 1) + ".png"));
                nclImages.add(saveIndividualImage(date, cycle,
                        "GFS_IMAGES/GFS_NCL.0000" + ((i + 1 >= 10) ? "" : "0") + (i + 1) + ".png"));
                cycle = (cycle + timeStep) % 24;
                date = cycle % 24 == 0 ? date.plusDays(1) : date;
            }
            Gfs gfs = Gfs.GFSBuilder.aGFS()
                    .withStart(LocalDate.now())
                    .withGradsImages(gradsImages)
                    .withNclImages(nclImages)
                    .build();
            gfsRepository.save(gfs);
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Loads and saves image to the repository.
     *
     * @param date     of image.
     * @param cycle    of image.
     * @param filename to search by.
     * @return the loaded image.
     */
    private GfsImage saveIndividualImage(LocalDate date, int cycle, String filename) throws IOException {
        LocalDateTime localDateTime = LocalDateTime.of(date, LocalTime.of(cycle, 0));
        ClassPathResource backImgFileGRADS = new ClassPathResource(filename);
        byte[] arrayPic = new byte[(int) backImgFileGRADS.contentLength()];

        backImgFileGRADS.getInputStream().read(arrayPic);
        GfsImage gfsImage = GfsImage.GFSImageBuilder.aGFSImage()
                .withImage(arrayPic)
                .withDateTime(localDateTime)
                .build();
        gfsImageRepository.save(gfsImage);
        return gfsImage;
    }

    @Override
    public boolean existsGFSByStartEquals(LocalDate date) {
        LOGGER.debug("Check if Gfs with {} exists.", date);
        try {
            return gfsRepository.existsGFSByStartEquals(date);
        } catch (DataAccessException e) {
            throw new NotFoundException(String.format("Could not find gfs with date %s", date));
        }
    }

    @Override
    public List<LocalDate> getAvailableDates() {
        LOGGER.debug("Get available dates.");

        try {
            return gfsRepository.getAllDates();
        } catch (DataAccessException e) {
            throw new NotFoundException("Database is empty.");
        }
    }
}

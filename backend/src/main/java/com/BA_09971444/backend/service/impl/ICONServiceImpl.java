package com.BA_09971444.backend.service.impl;

import com.BA_09971444.backend.entity.ICON;
import com.BA_09971444.backend.entity.ICONImage;
import com.BA_09971444.backend.exception.NotFoundException;
import com.BA_09971444.backend.repository.ICONImageRepository;
import com.BA_09971444.backend.repository.ICONRepository;
import com.BA_09971444.backend.service.ICONService;
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
import java.util.Set;

@Service
public class ICONServiceImpl implements ICONService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final ICONImageRepository iconImageRepository;
    private final ICONRepository iconRepository;

    public ICONServiceImpl(ICONImageRepository iconImageRepository, ICONRepository iconRepository) {
        this.iconImageRepository = iconImageRepository;
        this.iconRepository = iconRepository;
    }

    @Override
    public ICON getICONOutputByDate(LocalDate date) {
        LOGGER.debug("Get ICON Output by date {}", date);

        try {
            return iconRepository.findByStartEquals(date);
        } catch (DataAccessException e) {
            throw new NotFoundException(String.format("Could not find icon with date %s", date));
        }
    }

    @Transactional
    @Override
    public void saveICONImages(LocalDate date) {
        LOGGER.debug("Saving ICON Images.");

        Set<ICONImage> gradsImages = new HashSet<>();
        Set<ICONImage> nclImages = new HashSet<>();
        try {
            int amountOfImages = 11;
            int cycle = 0;
            int timeStep = 12;
            for (int i = 0; i < amountOfImages; i++) {
                gradsImages.add(saveIndividualImage(date, cycle, "ICON_IMAGES/ICON_GrADs_" + (i + 1) + ".png"));
                nclImages.add(saveIndividualImage(date, cycle, "ICON_IMAGES/ICON_NCL.0000" + ((i + 1 >= 10) ? "" : "0") + (i + 1) + ".png"));

                cycle = (cycle + timeStep) % 24;
                date = cycle % 24 == 0 ? date.plusDays(1) : date;
            }
            ICON icon = ICON.ICONBuilder.anICON()
                    .withStart(LocalDate.now())
                    .withGradsImages(gradsImages)
                    .withNclImages(nclImages)
                    .build();
            iconRepository.save(icon);
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
    private ICONImage saveIndividualImage(LocalDate date, int cycle, String filename) throws IOException {
        LocalDateTime localDateTime = LocalDateTime.of(date, LocalTime.of(cycle, 0));
        ClassPathResource backImgFileGRADS = new ClassPathResource(filename);
        byte[] arrayPic = new byte[(int) backImgFileGRADS.contentLength()];

        backImgFileGRADS.getInputStream().read(arrayPic);
        ICONImage iconImage = ICONImage.ICONImageBuilder.aICONImage()
                .withImage(arrayPic)
                .withDateTime(localDateTime)
                .build();
        iconImageRepository.save(iconImage);
        return iconImage;
    }

    @Override
    public boolean existsICONByStartEquals(LocalDate date) {
        try {
            return iconRepository.existsICONByStartEquals(date);
        } catch (DataAccessException e) {
            throw new NotFoundException(String.format("Could not find gfs with date %s", date));
        }
    }

}

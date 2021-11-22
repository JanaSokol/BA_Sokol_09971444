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

import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

// TODO Exception Handling
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
    public List<ICONImage> getICONOutputByDate(LocalDate date) {
        LOGGER.debug("Get ICON Output by date {}", date);

        try {
            ICON icon = iconRepository.findByStartEquals(date);
            return new ArrayList<>(icon.getImages());
        } catch (DataAccessException e) {
            throw new NotFoundException(String.format("Could not find icon with date %s", date));
        }
    }

    @Override
    public void saveICONImages() {
        LOGGER.debug("Saving ICON Images.");

        Set<ICONImage> iconImages = new HashSet<>();
        try {
            int amountOfImages = 11;
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
        } catch (IOException e) {
            // TODO
            e.printStackTrace();
        }
    }

    @Override
    public boolean existsICONByStartEquals(LocalDate date) {
        return iconRepository.existsICONByStartEquals(date);
    }
}

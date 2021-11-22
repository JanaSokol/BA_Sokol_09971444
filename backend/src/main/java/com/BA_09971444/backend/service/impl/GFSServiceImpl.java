package com.BA_09971444.backend.service.impl;

import com.BA_09971444.backend.entity.GFS;
import com.BA_09971444.backend.entity.GFSImage;
import com.BA_09971444.backend.exception.NotFoundException;
import com.BA_09971444.backend.repository.GFSImageRepository;
import com.BA_09971444.backend.repository.GFSRepository;
import com.BA_09971444.backend.service.GFSService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

// TODO Exception Handling
@Service
public class GFSServiceImpl implements GFSService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final GFSImageRepository gfsImageRepository;
    private final GFSRepository gfsRepository;

    public GFSServiceImpl(GFSImageRepository gfsImageRepository, GFSRepository gfsRepository) {
        this.gfsImageRepository = gfsImageRepository;
        this.gfsRepository = gfsRepository;
    }

    @Transactional
    @Override
    public List<GFSImage> getGFSOutputByDate(LocalDate date) {
        LOGGER.debug("Get GFS Output by date {}", date);

        try {
            GFS gfs = gfsRepository.findByStartEquals(date);
            return new ArrayList<>(gfs.getImages());
        } catch (DataAccessException e) {
            throw new NotFoundException(String.format("Could not find gfs with date %s", date));
        }
    }

    @Transactional
    @Override
    public void saveGFSImages() {
        LOGGER.debug("Saving GFS Images.");

        Set<GFSImage> gfsImages = new HashSet<>();
        try {
            int amountOfImages = 11;
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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean existsGFSByStartEquals(LocalDate date) {
        return gfsRepository.existsGFSByStartEquals(date);
    }

}

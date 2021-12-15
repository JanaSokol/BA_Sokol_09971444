package com.BA_09971444.backend.service;

import com.BA_09971444.backend.entity.IconImage;

import java.time.LocalDate;
import java.util.List;

public interface IconService {

    /**
     * Gets the Icon output for a specific time period.
     *
     * @param date    date to get Icon output by.
     * @param visType icon of the specific time period.
     * @return the icon image.
     */
    List<IconImage> getICONOutputByDate(LocalDate date, Long visType);

    /**
     * Saves all Icon images from the resource folder in the h2 database.
     *
     * @param date specific date to add.
     * @param path path of images.
     */
    void saveICONImages(LocalDate date, String path);

    /**
     * Checks if data has already been processed.
     *
     * @param date to check.
     * @return true if data for specific day already exists, false if nothing has been calculated so far.
     */
    boolean existsICONByStartEquals(LocalDate date);
}

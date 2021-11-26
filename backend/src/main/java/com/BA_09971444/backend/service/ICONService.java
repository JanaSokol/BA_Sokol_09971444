package com.BA_09971444.backend.service;

import com.BA_09971444.backend.entity.ICON;

import java.time.LocalDate;

public interface ICONService {

    /**
     * Gets the ICON output for a specific time period.
     *
     * @param date to get ICON output by.
     * @return icon of the specific time period.
     */
    ICON getICONOutputByDate(LocalDate date);

    /**
     * Saves all ICON images from the resource folder in the h2 database.
     */
    void saveICONImages(LocalDate date);

    /**
     * Checks if data has already been processed.
     *
     * @param date to check.
     * @return true if data for specific day already exists, false if nothing has been calculated so far.
     */
    boolean existsICONByStartEquals(LocalDate date);
}

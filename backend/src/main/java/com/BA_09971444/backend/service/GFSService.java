package com.BA_09971444.backend.service;

import com.BA_09971444.backend.entity.GFSImage;

import java.time.LocalDate;
import java.util.List;

public interface GFSService {


    /**
     * Gets the GFS output for a specific time period.
     *
     * @param date to get GFS output by.
     * @return list of gfs images for the specific time period.
     */
    List<GFSImage> getGFSOutputByDate(LocalDate date);

    /**
     * Saves all GFS images from the resource folder in the h2 database.
     */
    void saveGFSImages();

    /**
     * Checks if data has already been processed.
     *
     * @param date to check.
     * @return true if data for specific day already exists, false if nothing has been calculated so far.
     */
    boolean existsGFSByStartEquals(LocalDate date);

}

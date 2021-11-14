package com.BA_09971444.backend.service;

import com.BA_09971444.backend.entity.GFS;

public interface WRFService {

    /**
     * Gets the GFS output for a specific day.
     *
     * @param gfs to create
     * @return created gfs
     */
    GFS getGFSOutputByDate(GFS gfs);
}

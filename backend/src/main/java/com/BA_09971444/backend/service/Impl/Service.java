package com.BA_09971444.backend.service.Impl;

import com.BA_09971444.backend.entity.GFS;

public interface Service {

    /**
     * Gets the GFS output for a specific day.
     *
     * @param gfs to create
     * @return created gfs
     */
    GFS getGFSOutputByDate(GFS gfs);
}

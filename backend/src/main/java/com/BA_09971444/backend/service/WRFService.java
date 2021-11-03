package com.BA_09971444.backend.service;

import com.BA_09971444.backend.entity.DateTime;

public interface WRFService {

    /**
     * Gets the WRF output for a specific day.
     *
     * @param dateTime to calculate by.
     */
    void getWRFOutputByDate(DateTime dateTime);
}

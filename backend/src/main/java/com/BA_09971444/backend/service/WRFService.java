package com.BA_09971444.backend.service;

import java.sql.Date;

public interface WRFService {

    /**
     * Gets the WRF output for a specific day.
     * TODO
     * @param month to calculate WRF.
     */
    void getWRFOutputByDate(int day, int month, int year, int cycle);
}

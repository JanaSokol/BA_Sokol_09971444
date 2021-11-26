package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.ICON;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;

public interface ICONRepository extends JpaRepository<ICON, Long> {

    /**
     * Checks if ICON with specific date exists in the database.
     *
     * @param date to check.
     * @return true if ICON exists, false if there is no entry with this date.
     */
    Boolean existsICONByStartEquals(LocalDate date);

    /**
     * Finds ICON with a specific date.
     *
     * @param date to check.
     * @return ICON.
     */
    ICON findByStartEquals(LocalDate date);
}

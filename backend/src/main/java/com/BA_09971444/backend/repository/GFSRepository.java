package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.GFS;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface GFSRepository extends JpaRepository<GFS, Long> {

    /**
     * Checks if GFS with specific date exists in the database.
     *
     * @param date to check.
     * @return true if GFS exists, false if there is no entry with this date.
     */
    Boolean existsGFSByStartEquals(LocalDate date);

    /**
     * Finds GFS with a specific date.
     *
     * @param date to check.
     * @return GFS.
     */
    GFS findByStartEquals(LocalDate date);

    /**
     * Gets all dates.
     *
     * @return a list of dates.
     */
    @Query("select p.start from GFS p")
    List<LocalDate> getAllDates();

}

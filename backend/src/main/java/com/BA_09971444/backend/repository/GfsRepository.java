package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.Gfs;
import com.BA_09971444.backend.entity.GfsImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface GfsRepository extends JpaRepository<Gfs, Long> {

    /**
     * Checks if Gfs with specific date exists in the database.
     *
     * @param date to check.
     * @return true if Gfs exists, false if there is no entry with this date.
     */
    Boolean existsGFSByStartEquals(LocalDate date);

    /**
     * Gets all images with the visualization type ncl with a specific date.
     *
     * @param date to find.
     * @return a list of gfs images.
     */
    @Query("select p.nclImages from Gfs p where p.start = :date")
    List<GfsImage> getNclImages(LocalDate date);

    /**
     * Gets all images with the visualization type grads with a specific date.
     *
     * @param date to find.
     * @return a list of gfs images.
     */
    @Query("select p.gradsImages from Gfs p where p.start = :date")
    List<GfsImage> getGradsImages(LocalDate date);

    /**
     * Gets all dates.
     *
     * @return a list of dates.
     */
    @Query("select p.start from Gfs p")
    List<LocalDate> getAllDates();

}

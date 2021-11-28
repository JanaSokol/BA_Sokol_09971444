package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.Icon;
import com.BA_09971444.backend.entity.IconImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;

public interface IconRepository extends JpaRepository<Icon, Long> {

    /**
     * Checks if Icon with specific date exists in the database.
     *
     * @param date to check.
     * @return true if Icon exists, false if there is no entry with this date.
     */
    Boolean existsICONByStartEquals(LocalDate date);

    @Query("select p.nclImages from Icon p where p.start = :date")
    List<IconImage> getNclImages(LocalDate date);

    @Query("select p.gradsImages from Icon p where p.start = :date")
    List<IconImage> getGradsImages(LocalDate date);

    /**
     * Finds Icon with a specific date.
     *
     * @param date to check.
     * @return Icon.
     */
    Icon findByStartEquals(LocalDate date);
}

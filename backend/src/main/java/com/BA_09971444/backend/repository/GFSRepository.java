package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.GFS;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

@Repository
public interface GFSRepository extends JpaRepository<GFS, Long> {

    Boolean existsGFSByStartEquals(LocalDate date);

    GFS findByStartEquals(LocalDate date);

}

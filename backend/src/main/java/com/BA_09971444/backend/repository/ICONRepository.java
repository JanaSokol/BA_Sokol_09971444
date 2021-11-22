package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.ICON;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;

public interface ICONRepository extends JpaRepository<ICON, Long> {

    Boolean existsICONByStartEquals(LocalDate date);
}

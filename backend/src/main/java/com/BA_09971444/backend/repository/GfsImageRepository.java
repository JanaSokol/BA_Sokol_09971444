package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.GfsImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GfsImageRepository extends JpaRepository<GfsImage, Long> {
}

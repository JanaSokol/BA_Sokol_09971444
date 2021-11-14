package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.GFSImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GFSImageRepository extends JpaRepository<GFSImage, Long> {
}

package com.BA_09971444.backend.repository;

import com.BA_09971444.backend.entity.GFSImage;
import com.BA_09971444.backend.entity.ICONImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ICONImageRepository extends JpaRepository<ICONImage, Long> {
}

package com.BA_09971444.backend.endpoint.dto;

import com.BA_09971444.backend.entity.GfsImage;

import java.util.List;

public class SimpleGfsDto {

    private List<GfsImage> gradsImages;

    private List<GfsImage> nclImages;

    public void setGradsImages(List<GfsImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public void setNclImages(List<GfsImage> nclImages) {
        this.nclImages = nclImages;
    }

    @Override
    public String toString() {
        return "SimpleGfsDto{" +
                "gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }
}

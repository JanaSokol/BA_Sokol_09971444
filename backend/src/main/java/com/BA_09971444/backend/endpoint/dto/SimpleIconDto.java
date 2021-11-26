package com.BA_09971444.backend.endpoint.dto;

import com.BA_09971444.backend.entity.ICONImage;

import java.util.Set;

public class SimpleIconDto {

    private Set<ICONImage> gradsImages;

    private Set<ICONImage> nclImages;

    public void setGradsImages(Set<ICONImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public void setNclImages(Set<ICONImage> nclImages) {
        this.nclImages = nclImages;
    }

    @Override
    public String toString() {
        return "SimpleIconDto{" +
                "gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }
}

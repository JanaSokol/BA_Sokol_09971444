package com.BA_09971444.backend.endpoint.dto;

import com.BA_09971444.backend.entity.IconImage;

import java.util.List;

public class SimpleIconDto {

    private List<IconImage> gradsImages;

    private List<IconImage> nclImages;

    public void setGradsImages(List<IconImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public void setNclImages(List<IconImage> nclImages) {
        this.nclImages = nclImages;
    }


    public List<IconImage> getGradsImages() {
        return gradsImages;
    }

    public List<IconImage> getNclImages() {
        return nclImages;
    }

    @Override
    public String toString() {
        return "SimpleIconDto{" +
                "gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }
}

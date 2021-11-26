package com.BA_09971444.backend.endpoint.dto;

import com.BA_09971444.backend.entity.GFSImage;

import java.util.Set;

public class SimpleGfsDto {

    private Set<GFSImage> gradsImages;

    private Set<GFSImage> nclImages;

    public void setGradsImages(Set<GFSImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public void setNclImages(Set<GFSImage> nclImages) {
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

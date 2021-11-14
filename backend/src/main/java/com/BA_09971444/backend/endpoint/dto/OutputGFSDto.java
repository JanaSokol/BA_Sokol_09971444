package com.BA_09971444.backend.endpoint.dto;

import com.BA_09971444.backend.entity.GFSImage;

import java.util.Objects;
import java.util.Set;

public class OutputGFSDto {

    private Set<GFSImage> images;

    public Set<GFSImage> getImages() {
        return images;
    }

    public void setImages(Set<GFSImage> images) {
        this.images = images;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OutputGFSDto that = (OutputGFSDto) o;
        return Objects.equals(images, that.images);
    }

    @Override
    public int hashCode() {
        return Objects.hash(images);
    }

    @Override
    public String toString() {
        return "OutputGFSDto{" +
                "images=" + images +
                '}';
    }
}

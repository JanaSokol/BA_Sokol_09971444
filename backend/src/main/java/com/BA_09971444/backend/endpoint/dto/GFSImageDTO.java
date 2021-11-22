package com.BA_09971444.backend.endpoint.dto;

import java.util.Arrays;

public class GFSImageDTO {

    private byte[] image;

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "GFSImageDTO{" +
                "image=" + Arrays.toString(image) +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GFSImageDTO that = (GFSImageDTO) o;
        return Arrays.equals(image, that.image);
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(image);
    }
}

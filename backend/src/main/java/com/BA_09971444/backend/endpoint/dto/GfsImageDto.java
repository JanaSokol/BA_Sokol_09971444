package com.BA_09971444.backend.endpoint.dto;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Objects;

public class GfsImageDto {
    private Long id;
    private byte[] image;
    private LocalDateTime dateTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    @Override
    public String toString() {
        return "GfsImageDto{" +
                "id=" + id +
                ", image=" + Arrays.toString(image) +
                ", dateTime=" + dateTime +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GfsImageDto that = (GfsImageDto) o;
        return Objects.equals(id, that.id) && Arrays.equals(image, that.image) && Objects.equals(dateTime, that.dateTime);
    }

    @Override
    public int hashCode() {
        int result = Objects.hash(id, dateTime);
        result = 31 * result + Arrays.hashCode(image);
        return result;
    }
}

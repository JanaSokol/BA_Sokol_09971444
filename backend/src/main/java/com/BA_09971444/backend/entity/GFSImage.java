package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.util.Arrays;
import java.util.Objects;
import java.util.Set;

@Entity
public class GFSImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    @Column(nullable = false)
    private byte[] image;

    @ManyToMany(mappedBy = "images")
    private Set<GFS> gfsSet;

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

    public Set<GFS> getGfsSet() {
        return gfsSet;
    }

    public void setGfsSet(Set<GFS> gfsSet) {
        this.gfsSet = gfsSet;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GFSImage gfsImage = (GFSImage) o;
        return Objects.equals(id, gfsImage.id) && Arrays.equals(image, gfsImage.image) && Objects.equals(gfsSet, gfsImage.gfsSet);
    }

    @Override
    public String toString() {
        return "GFSImage{" +
                "id=" + id +
                ", Image=" + Arrays.toString(image) +
                ", gfsSet=" + gfsSet +
                '}';
    }

    public static final class GFSImageBuilder {
        private Long id;
        private byte[] image;

        private GFSImageBuilder() {
        }

        public static GFSImageBuilder aGFSImage() {
            return new GFSImageBuilder();
        }

        public GFSImageBuilder withId(Long id) {
            this.id = id;
            return this;
        }

        public GFSImageBuilder withImage(byte[] image) {
            this.image = image;
            return this;
        }

        public GFSImage build() {
            GFSImage gfsImage = new GFSImage();
            gfsImage.setId(id);
            gfsImage.setImage(image);
            return gfsImage;
        }
    }
}

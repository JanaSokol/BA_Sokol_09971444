package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.util.Arrays;
import java.util.Objects;
import java.util.Set;

@Entity
public class ICONImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    @Column(nullable = false)
    private byte[] image;

    @ManyToMany(mappedBy = "images")
    private Set<ICON> iconSet;

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

    public Set<ICON> getIconSet() {
        return iconSet;
    }

    public void setIconSet(Set<ICON> iconSet) {
        this.iconSet = iconSet;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ICONImage iconImage = (ICONImage) o;
        return Objects.equals(id, iconImage.id) && Arrays.equals(image, iconImage.image) && Objects.equals(iconSet, iconImage.iconSet);
    }

    @Override
    public String toString() {
        return "ICONImage{" +
                "id=" + id +
                ", Image=" + Arrays.toString(image) +
                ", iconSet=" + iconSet +
                '}';
    }

    public static final class ICONImageBuilder {
        private Long id;
        private byte[] image;

        private ICONImageBuilder() {
        }

        public static ICONImageBuilder aICONImage() {
            return new ICONImageBuilder();
        }

        public ICONImageBuilder withId(Long id) {
            this.id = id;
            return this;
        }

        public ICONImageBuilder withImage(byte[] image) {
            this.image = image;
            return this;
        }

        public ICONImage build() {
            ICONImage iconImage = new ICONImage();
            iconImage.setId(id);
            iconImage.setImage(image);
            return iconImage;
        }
    }
}

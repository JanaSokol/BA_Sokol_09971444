package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;

@Entity
public class IconImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    @Column(nullable = false)
    private byte[] image;

    @Column(nullable = false)
    private LocalDateTime dateTime;

    @ManyToMany(mappedBy = "gradsImages")
    private Set<Icon> gradsSet;

    @ManyToMany(mappedBy = "nclImages")
    private Set<Icon> nclSet;

    public void setImage(byte[] image) {
        this.image = image;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public byte[] getImage() {
        return image;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public Set<Icon> getGradsSet() {
        return gradsSet;
    }

    public void setGradsSet(Set<Icon> gradsSet) {
        this.gradsSet = gradsSet;
    }

    public Set<Icon> getNclSet() {
        return nclSet;
    }

    public void setNclSet(Set<Icon> nclSet) {
        this.nclSet = nclSet;
    }

    @Override
    public String toString() {
        return "IconImage{" +
                "id=" + id +
                ", Image=" + image.length +
                ", dateTime=" + dateTime +
                '}';
    }

    public static final class ICONImageBuilder {
        private byte[] image;
        private LocalDateTime dateTime;

        private ICONImageBuilder() {
        }

        public static ICONImageBuilder aICONImage() {
            return new ICONImageBuilder();
        }

        public ICONImageBuilder withImage(byte[] image) {
            this.image = image;
            return this;
        }

        public ICONImageBuilder withDateTime(LocalDateTime dateTime) {
            this.dateTime = dateTime;
            return this;
        }

        public IconImage build() {
            IconImage iconImage = new IconImage();
            iconImage.setImage(image);
            iconImage.setDateTime(dateTime);
            return iconImage;
        }
    }
}

package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;

@Entity
public class GfsImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    @Column(nullable = false)
    private byte[] image;

    @Column(nullable = false)
    private LocalDateTime dateTime;

    @ManyToMany(mappedBy = "gradsImages")
    private Set<Gfs> gradsSet;

    @ManyToMany(mappedBy = "nclImages")
    private Set<Gfs> nclSet;

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

    public Set<Gfs> getGradsSet() {
        return gradsSet;
    }

    public void setGradsSet(Set<Gfs> gradsSet) {
        this.gradsSet = gradsSet;
    }

    public Set<Gfs> getNclSet() {
        return nclSet;
    }

    public void setNclSet(Set<Gfs> nclSet) {
        this.nclSet = nclSet;
    }

    @Override
    public String toString() {
        return "GfsImage{" +
                "id=" + id +
                ", image=" + image.length +
                ", dateTime=" + dateTime +
                '}';
    }

    public static final class GFSImageBuilder {
        private byte[] image;
        private LocalDateTime dateTime;

        private GFSImageBuilder() {
        }

        public static GFSImageBuilder aGFSImage() {
            return new GFSImageBuilder();
        }

        public GFSImageBuilder withImage(byte[] image) {
            this.image = image;
            return this;
        }

        public GFSImageBuilder withDateTime(LocalDateTime dateTime) {
            this.dateTime = dateTime;
            return this;
        }

        public GfsImage build() {
            GfsImage gfsImage = new GfsImage();
            gfsImage.setImage(image);
            gfsImage.setDateTime(dateTime);
            return gfsImage;
        }
    }
}

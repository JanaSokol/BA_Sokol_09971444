package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;

@Entity
public class GFSImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    @Column(nullable = false)
    private byte[] image;

    @Column(nullable = false)
    private LocalDateTime dateTime;

    @ManyToMany(mappedBy = "gradsImages")
    private Set<GFS> gradsSet;

    @ManyToMany(mappedBy = "nclImages")
    private Set<GFS> nclSet;

    public void setImage(byte[] image) {
        this.image = image;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    @Override
    public String toString() {
        return "GFSImage{" +
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

        public GFSImage build() {
            GFSImage gfsImage = new GFSImage();
            gfsImage.setImage(image);
            gfsImage.setDateTime(dateTime);
            return gfsImage;
        }
    }
}

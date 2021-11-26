package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;

@Entity
public class ICONImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    @Column(nullable = false)
    private byte[] image;

    @Column(nullable = false)
    private LocalDateTime dateTime;

    @ManyToMany(mappedBy = "gradsImages")
    private Set<ICON> gradsSet;

    @ManyToMany(mappedBy = "nclImages")
    private Set<ICON> nclSet;

    public void setImage(byte[] image) {
        this.image = image;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    @Override
    public String toString() {
        return "ICONImage{" +
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

        public ICONImage build() {
            ICONImage iconImage = new ICONImage();
            iconImage.setImage(image);
            iconImage.setDateTime(dateTime);
            return iconImage;
        }
    }
}

package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Set;

@Entity
public class ICON {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate start;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "ICON_GRADS_IMAGE_ASSOCIATION")
    private Set<ICONImage> gradsImages;


    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "ICON_NCL_IMAGE_ASSOCIATION")
    private Set<ICONImage> nclImages;

    public void setStart(LocalDate start) {
        this.start = start;
    }

    public Set<ICONImage> getGradsImages() {
        return gradsImages;
    }

    public void setGradsImages(Set<ICONImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public Set<ICONImage> getNclImages() {
        return nclImages;
    }

    public void setNclImages(Set<ICONImage> nclImages) {
        this.nclImages = nclImages;
    }

    @Override
    public String toString() {
        return "ICON{" +
                "id=" + id +
                ", start=" + start +
                ", gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }

    public static final class ICONBuilder {
        private LocalDate start;
        private Set<ICONImage> gradsImages;
        private Set<ICONImage> nclImages;

        private ICONBuilder() {
        }

        public static ICONBuilder anICON() {
            return new ICONBuilder();
        }

        public ICONBuilder withStart(LocalDate start) {
            this.start = start;
            return this;
        }

        public ICONBuilder withGradsImages(Set<ICONImage> images) {
            this.gradsImages = images;
            return this;
        }

        public ICONBuilder withNclImages(Set<ICONImage> nclImages) {
            this.nclImages = nclImages;
            return this;
        }

        public ICON build() {
            ICON icon = new ICON();
            icon.setStart(start);
            icon.setGradsImages(gradsImages);
            icon.setNclImages(nclImages);
            return icon;
        }
    }
}

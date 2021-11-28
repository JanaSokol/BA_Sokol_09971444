package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Set;

@Entity
public class Icon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate start;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "ICON_GRADS_IMAGE_ASSOCIATION")
    private Set<IconImage> gradsImages;


    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "ICON_NCL_IMAGE_ASSOCIATION")
    private Set<IconImage> nclImages;

    public void setStart(LocalDate start) {
        this.start = start;
    }

    public Set<IconImage> getGradsImages() {
        return gradsImages;
    }

    public void setGradsImages(Set<IconImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public Set<IconImage> getNclImages() {
        return nclImages;
    }

    public void setNclImages(Set<IconImage> nclImages) {
        this.nclImages = nclImages;
    }

    @Override
    public String toString() {
        return "Icon{" +
                "id=" + id +
                ", start=" + start +
                ", gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }

    public static final class ICONBuilder {
        private LocalDate start;
        private Set<IconImage> gradsImages;
        private Set<IconImage> nclImages;

        private ICONBuilder() {
        }

        public static ICONBuilder anICON() {
            return new ICONBuilder();
        }

        public ICONBuilder withStart(LocalDate start) {
            this.start = start;
            return this;
        }

        public ICONBuilder withGradsImages(Set<IconImage> images) {
            this.gradsImages = images;
            return this;
        }

        public ICONBuilder withNclImages(Set<IconImage> nclImages) {
            this.nclImages = nclImages;
            return this;
        }

        public Icon build() {
            Icon icon = new Icon();
            icon.setStart(start);
            icon.setGradsImages(gradsImages);
            icon.setNclImages(nclImages);
            return icon;
        }
    }
}

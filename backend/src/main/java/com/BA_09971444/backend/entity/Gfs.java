package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Set;

@Entity
public class Gfs {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate start;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "GFS_GRADS_IMAGE_ASSOCIATION")
    private Set<GfsImage> gradsImages;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "GFS_NCL_IMAGE_ASSOCIATION")
    private Set<GfsImage> nclImages;

    public void setStart(LocalDate start) {
        this.start = start;
    }

    public Set<GfsImage> getGradsImages() {
        return gradsImages;
    }

    public void setGradsImages(Set<GfsImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public Set<GfsImage> getNclImages() {
        return nclImages;
    }

    public void setNclImages(Set<GfsImage> nclImages) {
        this.nclImages = nclImages;
    }

    @Override
    public String toString() {
        return "Gfs{" +
                "id=" + id +
                ", start=" + start +
                ", gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }

    public static final class GFSBuilder {
        private LocalDate start;
        private Set<GfsImage> gradsImages;
        private Set<GfsImage> nclImages;

        private GFSBuilder() {
        }

        public static GFSBuilder aGFS() {
            return new GFSBuilder();
        }

        public GFSBuilder withStart(LocalDate start) {
            this.start = start;
            return this;
        }

        public GFSBuilder withGradsImages(Set<GfsImage> gradsImages) {
            this.gradsImages = gradsImages;
            return this;
        }

        public GFSBuilder withNclImages(Set<GfsImage> nclImages) {
            this.nclImages = nclImages;
            return this;
        }

        public Gfs build() {
            Gfs gfs = new Gfs();
            gfs.setStart(start);
            gfs.setGradsImages(gradsImages);
            gfs.setNclImages(nclImages);
            return gfs;
        }
    }
}

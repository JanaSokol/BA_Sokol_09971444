package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Set;

@Entity
public class GFS {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate start;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "GFS_GRADS_IMAGE_ASSOCIATION")
    private Set<GFSImage> gradsImages;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "GFS_NCL_IMAGE_ASSOCIATION")
    private Set<GFSImage> nclImages;

    public void setStart(LocalDate start) {
        this.start = start;
    }

    public Set<GFSImage> getGradsImages() {
        return gradsImages;
    }

    public void setGradsImages(Set<GFSImage> gradsImages) {
        this.gradsImages = gradsImages;
    }

    public Set<GFSImage> getNclImages() {
        return nclImages;
    }

    public void setNclImages(Set<GFSImage> nclImages) {
        this.nclImages = nclImages;
    }

    @Override
    public String toString() {
        return "GFS{" +
                "id=" + id +
                ", start=" + start +
                ", gradsImages=" + gradsImages +
                ", nclImages=" + nclImages +
                '}';
    }

    public static final class GFSBuilder {
        private LocalDate start;
        private Set<GFSImage> gradsImages;
        private Set<GFSImage> nclImages;

        private GFSBuilder() {
        }

        public static GFSBuilder aGFS() {
            return new GFSBuilder();
        }

        public GFSBuilder withStart(LocalDate start) {
            this.start = start;
            return this;
        }

        public GFSBuilder withGradsImages(Set<GFSImage> gradsImages) {
            this.gradsImages = gradsImages;
            return this;
        }

        public GFSBuilder withNclImages(Set<GFSImage> nclImages) {
            this.nclImages = nclImages;
            return this;
        }

        public GFS build() {
            GFS gfs = new GFS();
            gfs.setStart(start);
            gfs.setGradsImages(gradsImages);
            gfs.setNclImages(nclImages);
            return gfs;
        }
    }
}

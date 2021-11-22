package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Set;

@Entity
public class GFS {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate start;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "GFS_IMAGE_ASSOCIATION")
    private Set<GFSImage> images;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getStart() {
        return start;
    }

    public void setStart(LocalDate start) {
        this.start = start;
    }

    public Set<GFSImage> getImages() {
        return images;
    }

    public void setImages(Set<GFSImage> images) {
        this.images = images;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GFS gfs = (GFS) o;
        return Objects.equals(id, gfs.id) && Objects.equals(start, gfs.start) && Objects.equals(images, gfs.images);
    }

    @Override
    public String toString() {
        return "GFS{" +
                "id=" + id +
                ", start=" + start +
                ", images=" + images +
                '}';
    }

    public static final class GFSBuilder {
        private Long id;
        private LocalDate start;
        private Set<GFSImage> images;

        private GFSBuilder() {
        }

        public static GFSBuilder aGFS() {
            return new GFSBuilder();
        }

        public GFSBuilder withId(Long id) {
            this.id = id;
            return this;
        }

        public GFSBuilder withStart(LocalDate start) {
            this.start = start;
            return this;
        }

        public GFSBuilder withImages(Set<GFSImage> images) {
            this.images = images;
            return this;
        }

        public GFS build() {
            GFS gfs = new GFS();
            gfs.setId(id);
            gfs.setStart(start);
            gfs.setImages(images);
            return gfs;
        }
    }
}

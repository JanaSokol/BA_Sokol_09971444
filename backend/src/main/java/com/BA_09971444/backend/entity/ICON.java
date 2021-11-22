package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Objects;
import java.util.Set;

@Entity
public class ICON {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate start;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "ICON_IMAGE_ASSOCIATION")
    private Set<ICONImage> images;

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

    public Set<ICONImage> getImages() {
        return images;
    }

    public void setImages(Set<ICONImage> images) {
        this.images = images;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ICON icon = (ICON) o;
        return Objects.equals(id, icon.id) && Objects.equals(start, icon.start) && Objects.equals(images, icon.images);
    }

    @Override
    public String toString() {
        return "ICON{" +
                "id=" + id +
                ", start=" + start +
                ", images=" + images +
                '}';
    }

    public static final class ICONBuilder {
        private Long id;
        private LocalDate start;
        private Set<ICONImage> images;

        private ICONBuilder() {
        }

        public static ICONBuilder anICON() {
            return new ICONBuilder();
        }

        public ICONBuilder withId(Long id) {
            this.id = id;
            return this;
        }

        public ICONBuilder withStart(LocalDate start) {
            this.start = start;
            return this;
        }

        public ICONBuilder withImages(Set<ICONImage> images) {
            this.images = images;
            return this;
        }

        public ICON build() {
            ICON icon = new ICON();
            icon.setId(id);
            icon.setStart(start);
            icon.setImages(images);
            return icon;
        }
    }
}

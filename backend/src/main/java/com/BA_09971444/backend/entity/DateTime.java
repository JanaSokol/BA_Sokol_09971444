package com.BA_09971444.backend.entity;

import java.time.LocalDate;
import java.util.Objects;

public class DateTime {


    private LocalDate date;
    private Long cycle;

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Long getCycle() {
        return cycle;
    }

    public void setCycle(Long cycle) {
        this.cycle = cycle;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DateTime dateTime = (DateTime) o;
        return Objects.equals(date, dateTime.date) && Objects.equals(cycle, dateTime.cycle);
    }

    @Override
    public int hashCode() {
        return Objects.hash(date, cycle);
    }

    @Override
    public String toString() {
        return "DateTime{" +
                "date=" + date +
                ", cycle=" + cycle +
                '}';
    }
}

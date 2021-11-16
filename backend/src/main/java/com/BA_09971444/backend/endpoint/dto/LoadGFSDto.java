package com.BA_09971444.backend.endpoint.dto;

import java.time.LocalDate;
import java.util.Objects;

public class LoadGFSDto {

    private LocalDate start;
    private LocalDate end;
    private Long cycle;

    public LocalDate getStart() {
        return start;
    }

    public void setStart(LocalDate start) {
        this.start = start;
    }

    public LocalDate getEnd() {
        return end;
    }

    public void setEnd(LocalDate end) {
        this.end = end;
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
        LoadGFSDto that = (LoadGFSDto) o;
        return Objects.equals(start, that.start) && Objects.equals(end, that.end) && Objects.equals(cycle, that.cycle);
    }

    @Override
    public int hashCode() {
        return Objects.hash(start, end, cycle);
    }

    @Override
    public String toString() {
        return "LoadGFSDto{" +
                "start=" + start +
                ", end=" + end +
                ", cycle=" + cycle +
                '}';
    }




}

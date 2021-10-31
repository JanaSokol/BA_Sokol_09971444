package com.BA_09971444.backend.endpoint.dto;

import java.util.Objects;

public class TestDto {

    private Long id;
    private String text;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String test) {
        this.text = text;
    }

    @Override
    public String toString() {
        return "TestDto{" +
                "id=" + id +
                ", test='" + text + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TestDto testDto = (TestDto) o;
        return Objects.equals(id, testDto.id) && Objects.equals(text, testDto.text);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, text);
    }

    public TestDto build() {
        TestDto testDto = new TestDto();
        testDto.setId(id);
        testDto.setText(text);

        return testDto;
    }

}

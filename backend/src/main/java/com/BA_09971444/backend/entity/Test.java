package com.BA_09971444.backend.entity;

import javax.persistence.*;
import java.util.Objects;

/**
 * Test
 *
 * Represents a test object.
 */
@Entity
public class Test {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 10000)
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

    public void setText(String text) {
        this.text = text;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Test test1 = (Test) o;
        return Objects.equals(id, test1.id) && Objects.equals(text, test1.text);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, text);
    }

    @Override
    public String toString() {
        return "Test{" +
                "id=" + id +
                ", test='" + text + '\'' +
                '}';
    }


    public static final class TestBuilder {
        private Long id;
        private String text;

        private TestBuilder() {

        }

        public static TestBuilder aTest() {
            return new TestBuilder();
        }

        public TestBuilder withId(Long id) {
            this.id = id;
            return this;
        }

        public TestBuilder withText(String text) {
            this.text = text;
            return this;
        }

        public Test build() {
            Test test = new Test();
            test.setId(id);
            test.setText(text);

            return test;
        }
    }
}

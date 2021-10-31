package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.TestDto;
import com.BA_09971444.backend.entity.Test;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface TestMapper {

    /**
     * Maps a test object to a testDto
     * @param test that is to be mapped
     * @return a testDto object that contains the values of the corresponding test object
     */
    TestDto testToTestDto(Test test);
}

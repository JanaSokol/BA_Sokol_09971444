package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.TestDto;
import com.BA_09971444.backend.entity.Test;
import org.mapstruct.Mapper;

@Mapper
public interface TestMapper {

    TestDto testToTestDto(Test test);

    Test testDtoToTest(TestDto testDto);
}

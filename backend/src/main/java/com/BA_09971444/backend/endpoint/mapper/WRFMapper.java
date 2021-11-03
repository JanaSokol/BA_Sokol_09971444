package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.DateTimeDto;
import com.BA_09971444.backend.entity.DateTime;

import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface WRFMapper {

    DateTime dateToDateTimeDto(DateTimeDto dateTimeDto);
}

package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.SimpleIconDto;
import com.BA_09971444.backend.entity.Icon;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface IconMapper {

    /**
     * Maps a Icon entity to a simpleIconDto.
     *
     * @param icon to map.
     * @return a simpleIconDto.
     */
    SimpleIconDto iconToSimpleIconDto(Icon icon);
}

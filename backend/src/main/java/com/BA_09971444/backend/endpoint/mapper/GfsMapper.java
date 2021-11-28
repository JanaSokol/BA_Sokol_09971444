package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.SimpleGfsDto;
import com.BA_09971444.backend.entity.Gfs;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface GfsMapper {

    /**
     * Maps a Gfs entity to a simpleGfsDto.
     *
     * @param gfs to map.
     * @return a simpleGfsDto.
     */
    SimpleGfsDto gfsToSimpleGfsDto(Gfs gfs);
}

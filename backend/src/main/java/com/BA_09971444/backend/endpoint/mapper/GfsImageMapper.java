package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.GfsImageDto;
import com.BA_09971444.backend.entity.GfsImage;
import org.mapstruct.IterableMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Named;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GfsImageMapper {

    @Named("gfsImageDto")
    GfsImageDto gfsImageToGfsImageDto(GfsImage gfsImage);

    @IterableMapping(qualifiedByName = "gfsImageDto")
    List<GfsImageDto> gfsImageListToGfsImageListDto(List<GfsImage> gfsImages);
}

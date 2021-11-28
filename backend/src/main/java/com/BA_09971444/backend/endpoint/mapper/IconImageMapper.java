package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.IconImageDto;
import com.BA_09971444.backend.entity.IconImage;
import org.mapstruct.IterableMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Named;

import java.util.List;

@Mapper(componentModel = "spring")
public interface IconImageMapper {

    @Named("iconImageDto")
    IconImageDto iconImageToIconImageDto(IconImage iconImage);

    @IterableMapping(qualifiedByName = "iconImageDto")
    List<IconImageDto> iconImageListToIconImageListDto(List<IconImage> iconImages);
}

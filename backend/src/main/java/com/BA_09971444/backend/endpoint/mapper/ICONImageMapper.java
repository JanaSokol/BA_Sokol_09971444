package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.ICONImageDTO;
import com.BA_09971444.backend.entity.ICONImage;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ICONImageMapper {

    List<ICONImageDTO> iconImageToIconImageDTO(List<ICONImage> iconImages);
}

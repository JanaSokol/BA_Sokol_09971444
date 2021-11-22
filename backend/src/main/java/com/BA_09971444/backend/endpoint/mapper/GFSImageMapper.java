package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.GFSImageDTO;
import com.BA_09971444.backend.entity.GFSImage;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GFSImageMapper {

    List<GFSImageDTO> gfsImageToGfsImageDTO(List<GFSImage> gfsImages);
}

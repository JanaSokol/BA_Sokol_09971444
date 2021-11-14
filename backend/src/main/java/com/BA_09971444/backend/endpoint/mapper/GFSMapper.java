package com.BA_09971444.backend.endpoint.mapper;

import com.BA_09971444.backend.endpoint.dto.LoadGFSDto;

import com.BA_09971444.backend.endpoint.dto.OutputGFSDto;
import com.BA_09971444.backend.entity.GFS;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface GFSMapper {

    GFS loadGFSDtoToGFS(LoadGFSDto loadGFSDto);

    OutputGFSDto gfsToOutputGFSDto(GFS gfs);
}

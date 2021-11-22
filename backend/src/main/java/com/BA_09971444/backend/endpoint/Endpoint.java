package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.LoadGFSDto;
import com.BA_09971444.backend.endpoint.dto.OutputGFSDto;
import com.BA_09971444.backend.endpoint.mapper.GFSMapper;
import com.BA_09971444.backend.service.Impl.ServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.lang.invoke.MethodHandles;

@RestController
//CrossOrigin is needed otherwise we get a CORS Error
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping(value = "/weather")
public class Endpoint {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    // Services
    private final ServiceImpl wrfService;

    //Mapper
    private final GFSMapper gfsMapper;

    @Autowired
    public Endpoint(ServiceImpl wrfService, GFSMapper gfsMapper) {
        this.wrfService = wrfService;
        this.gfsMapper = gfsMapper;
    }


    /*------------------------- GFS -------------------------*/

    /**
     * Gets gfs output for a specific day.
     */
    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(path = "/gfs", consumes = MediaType.APPLICATION_JSON_VALUE)
    public OutputGFSDto getWRFOutputByDate(@RequestBody LoadGFSDto loadGFSDto) {
        LOGGER.info("GET /weather/gfs/{}", loadGFSDto);

        return gfsMapper.gfsToOutputGFSDto(wrfService.getGFSOutputByDate(gfsMapper.loadGFSDtoToGFS(loadGFSDto)));
    }
}

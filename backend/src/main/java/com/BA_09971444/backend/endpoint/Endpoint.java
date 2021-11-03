package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.DateTimeDto;
import com.BA_09971444.backend.endpoint.mapper.WRFMapper;
import com.BA_09971444.backend.service.Impl.WRFServiceImpl;
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
    private final WRFServiceImpl wrfService;

    //Mapper
    private final WRFMapper wrfMapper;

    @Autowired
    public Endpoint(WRFServiceImpl wrfService, WRFMapper wrfMapper) {
        this.wrfService = wrfService;
        this.wrfMapper = wrfMapper;
    }


    /*------------------------- WRF -------------------------*/

    /**
     * Gets wrf output for a specific day.
     */
    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(path = "/wrf", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void getWRFOutputByDate(@RequestBody DateTimeDto dateTimeDto) {
        LOGGER.info("GET /weather/wrf/{}", dateTimeDto);

        wrfService.getWRFOutputByDate(wrfMapper.dateToDateTimeDto(dateTimeDto));
    }
}

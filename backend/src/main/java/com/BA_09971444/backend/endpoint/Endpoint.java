package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.SimpleGfsDto;
import com.BA_09971444.backend.endpoint.dto.SimpleIconDto;
import com.BA_09971444.backend.endpoint.mapper.GfsMapper;
import com.BA_09971444.backend.endpoint.mapper.IconMapper;
import com.BA_09971444.backend.service.GFSService;
import com.BA_09971444.backend.service.ICONService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.lang.invoke.MethodHandles;
import java.time.LocalDate;
import java.util.List;

@RestController
//CrossOrigin is needed otherwise we get a CORS Error
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping(value = "/weather")
public class Endpoint {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    // Services
    private final GFSService gfsService;
    private final ICONService iconService;

    //Mapper
    private final GfsMapper gfsImageMapper;
    private final IconMapper iconImageMapper;

    @Autowired
    public Endpoint(GFSService gfsService, ICONService iconService, GfsMapper gfsImageMapper, IconMapper iconImageMapper) {
        this.gfsService = gfsService;
        this.iconService = iconService;
        this.gfsImageMapper = gfsImageMapper;
        this.iconImageMapper = iconImageMapper;
    }


    /*------------------------- GFS -------------------------*/

    /**
     * Gets gfs output for a specific day.
     */
    @GetMapping(path = "/gfs")
    public SimpleGfsDto getGFSOutputByDate(@RequestParam
                                           @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        LOGGER.info("GET /weather/gfs/{}", date);

        return gfsImageMapper.gfsToSimpleGfsDto(gfsService.getGFSOutputByDate(date));
    }

    /*------------------------- ICON -------------------------*/

    /**
     * Gets icon output for a specific day.
     */
    @GetMapping(path = "/icon")
    public SimpleIconDto getICONOutputByDate(@RequestParam
                                             @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        LOGGER.info("GET /weather/icon/{}", date);

        return iconImageMapper.iconToSimpleIconDto(iconService.getICONOutputByDate(date));
    }

    /**
     * Gets a list of dates that are available in the backend.
     *
     * @return list of dates.
     */
    @GetMapping()
    public List<LocalDate> getAvailableDates() {
        LOGGER.info("GET /weather");

        return gfsService.getAvailableDates();
    }
}

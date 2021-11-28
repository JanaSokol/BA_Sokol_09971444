package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.GfsImageDto;
import com.BA_09971444.backend.endpoint.dto.IconImageDto;
import com.BA_09971444.backend.endpoint.mapper.GfsImageMapper;
import com.BA_09971444.backend.endpoint.mapper.GfsMapper;
import com.BA_09971444.backend.endpoint.mapper.IconImageMapper;
import com.BA_09971444.backend.endpoint.mapper.IconMapper;
import com.BA_09971444.backend.service.GfsService;
import com.BA_09971444.backend.service.IconService;
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
    private final GfsService gfsService;
    private final IconService iconService;

    //Mapper
    private final GfsMapper gfsMapper;
    private final IconMapper iconMapper;
    private final IconImageMapper iconImageMapper;
    private final GfsImageMapper gfsImageMapper;

    @Autowired
    public Endpoint(GfsService gfsService, IconService iconService, GfsMapper gfsMapper, IconMapper iconMapper, IconImageMapper iconImageMapper, GfsImageMapper gfsImageMapper) {
        this.gfsService = gfsService;
        this.iconService = iconService;
        this.gfsMapper = gfsMapper;
        this.iconMapper = iconMapper;
        this.iconImageMapper = iconImageMapper;
        this.gfsImageMapper = gfsImageMapper;
    }


    /*------------------------- Gfs -------------------------*/

    /**
     * Gets gfs output for a specific day.
     */
    @GetMapping(path = "/gfs")
    public List<GfsImageDto> getGFSOutputByDate(@RequestParam
                                           @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date , @RequestParam Long visType) {
        LOGGER.info("GET /weather/gfs/{}{}", date, visType);

       return gfsImageMapper.gfsImageListToGfsImageListDto(gfsService.getGFSOutputByDate(date, visType));
    }

    /*------------------------- Icon -------------------------*/

    /**
     * Gets icon output for a specific day.
     */
    @GetMapping(path = "/icon")
    public List<IconImageDto> getICONOutputByDate(@RequestParam
                                             @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date, @RequestParam Long visType) {
        LOGGER.info("GET /weather/icon/{}{}", date, visType);

        return iconImageMapper.iconImageListToIconImageListDto(iconService.getICONOutputByDate(date,visType));
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

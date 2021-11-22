package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.GFSImageDTO;
import com.BA_09971444.backend.endpoint.dto.ICONImageDTO;
import com.BA_09971444.backend.endpoint.mapper.GFSImageMapper;
import com.BA_09971444.backend.endpoint.mapper.ICONImageMapper;
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
    private final GFSImageMapper gfsImageMapper;
    private final ICONImageMapper iconImageMapper;

    @Autowired
    public Endpoint(GFSService gfsService, ICONService iconService, GFSImageMapper gfsImageMapper, ICONImageMapper iconImageMapper) {
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
    public List<GFSImageDTO> getGFSOutputByDate(@RequestParam
                                                @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        LOGGER.info("GET /weather/gfs/{}", date);

        // TODO
        return gfsImageMapper.gfsImageToGfsImageDTO(gfsService.getGFSOutputByDate(date));
    }

    /*------------------------- ICON -------------------------*/

    /**
     * Gets icon output for a specific day.
     */
    @GetMapping(path = "/icon")
    public List<ICONImageDTO> getICONOutputByDate(@RequestParam
                                                  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        LOGGER.info("GET /weather/icon/{}", date);

        // TODO
        return iconImageMapper.iconImageToIconImageDTO(iconService.getICONOutputByDate(date));
    }
}

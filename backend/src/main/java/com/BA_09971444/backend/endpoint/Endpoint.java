package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.TestDto;
import com.BA_09971444.backend.endpoint.mapper.TestMapper;
import com.BA_09971444.backend.service.Impl.TestServiceImpl;
import com.BA_09971444.backend.service.Impl.WRFServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.lang.invoke.MethodHandles;
import java.sql.Date;

@RestController
//CrossOrigin is needed otherwise we get a CORS Error
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping(value = "/weather")
public class Endpoint {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    // Services
    private final TestServiceImpl service;
    private final WRFServiceImpl wrfService;

    //Mapper
    private final TestMapper testMapper;

    @Autowired
    public Endpoint(TestServiceImpl service, WRFServiceImpl wrfService, TestMapper testMapper) {
        this.service = service;
        this.wrfService = wrfService;
        this.testMapper = testMapper;
    }


    /*------------------------- WRF -------------------------*/

    /**
     * Gets wrf output for a specific day.
     *
     * @return wrf output.
     */
    @GetMapping(path = "/wrf/{day}/{month}/{year}/{cycle}")
    public int getWRFOutputByDate(@PathVariable("day") int day,@PathVariable("month") int month, @PathVariable("year") int year, @PathVariable("cycle") int cycle) {
        LOGGER.info("GET /weather/wrf/{}/{}/{}/{}", day, month, year, cycle);
        wrfService.getWRFOutputByDate(day, month, year, cycle);

        return 1;
    }





    /*------------------------- Test -------------------------*/
    /**
     * Gets a specific test by id.
     *
     * @param id of test to find
     * @return test
     */
    @GetMapping(value = "/{id}")
    public TestDto getTest(@PathVariable Long id) {
        LOGGER.info("GET /{}", id);
        return testMapper.testToTestDto(service.get(id));
    }
}

package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.TestDto;
import com.BA_09971444.backend.endpoint.mapper.TestMapper;
import com.BA_09971444.backend.service.Impl.TestServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.lang.invoke.MethodHandles;

@RestController
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping(value = "/weather")
public class Endpoint {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    private final TestServiceImpl service;
    private final TestMapper testMapper;

    @Autowired
    public Endpoint(TestServiceImpl service, TestMapper testMapper) {
        this.service = service;
        this.testMapper = testMapper;
    }

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

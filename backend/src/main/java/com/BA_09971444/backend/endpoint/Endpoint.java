package com.BA_09971444.backend.endpoint;

import com.BA_09971444.backend.endpoint.dto.TestDto;
import com.BA_09971444.backend.endpoint.mapper.TestMapper;
import com.BA_09971444.backend.service.Impl.TestServiceImpl;
import javassist.NotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.invoke.MethodHandles;

@RestController
@RequestMapping
public class Endpoint {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    private final TestServiceImpl service;
    private final TestMapper testMapper;

    @Autowired
    public Endpoint(TestServiceImpl service, TestMapper testMapper) {
        this.service = service;
        this.testMapper = testMapper;
    }


    @GetMapping(value = "/{id}")
    public TestDto getTest(@PathVariable Long id) throws NotFoundException {
        LOGGER.info("GET /{}", id);
        return testMapper.testToTestDto(service.get(id));
    }
}

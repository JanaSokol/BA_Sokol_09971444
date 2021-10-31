package com.BA_09971444.backend.service.Impl;

import com.BA_09971444.backend.entity.Test;
import com.BA_09971444.backend.exception.NotFoundException;
import com.BA_09971444.backend.repository.TestRepository;
import com.BA_09971444.backend.service.TestService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.lang.invoke.MethodHandles;
import java.util.Optional;


@Service
public class TestServiceImpl implements TestService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final TestRepository testRepository;

    public TestServiceImpl(TestRepository testRepository) {
        this.testRepository = testRepository;
    }

    @Override
    public Test get(Long id) {
        LOGGER.debug("Find test with if {}", id);

        Optional<Test> optionalTest = testRepository.findById(id);

        if (optionalTest.isPresent()) {
            Test test = optionalTest.get();

            return test;
        } else throw new NotFoundException(String.format("Could not find news with id %s", id));

    }
}

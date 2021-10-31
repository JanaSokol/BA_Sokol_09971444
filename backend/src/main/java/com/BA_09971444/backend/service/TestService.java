package com.BA_09971444.backend.service;

import com.BA_09971444.backend.entity.Test;
import javassist.NotFoundException;

public interface TestService {

    /**
     * Get one test entry by id.
     * @param id of test.
     * @return test.
     */
    Test get(Long id) throws NotFoundException;
}

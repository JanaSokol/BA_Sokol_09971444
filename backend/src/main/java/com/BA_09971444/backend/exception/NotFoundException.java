package com.BA_09971444.backend.exception;

/**
 * NotFoundException
 * <p>
 * An Exception which is thrown when an entity is not found in the database.
 */
public class NotFoundException extends RuntimeException {

    public NotFoundException(String message) {
        super(message);
    }
}
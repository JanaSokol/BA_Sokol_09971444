package com.BA_09971444.backend.exception;

/**
 * WRFBuildFailedException
 *
 * An Exception which is thrown when the main script of the WRF Model fails.
 */
public class WRFBuildFailedException extends RuntimeException {

    public WRFBuildFailedException(String message) {
        super(message);
    }
}

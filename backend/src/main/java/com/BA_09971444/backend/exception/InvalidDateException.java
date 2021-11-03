package com.BA_09971444.backend.exception;

/**
 * InvalidDateException
 *
 * An Exception which is thrown when the given date is invalid.
 */
public class InvalidDateException extends RuntimeException  {

    public InvalidDateException(String message) { super(message);}
}

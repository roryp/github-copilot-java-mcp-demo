package com.example.tododemo.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Thrown when a todo with a given id does not exist.
 * Mapped to an HTTP 404 response for the REST API.
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class TodoNotFoundException extends RuntimeException {

    public TodoNotFoundException(Long id) {
        super("Todo " + id + " not found");
    }
}

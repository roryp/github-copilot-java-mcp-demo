package com.example.tododemo.web.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * Request body for updating a todo's title and completion status.
 */
public record UpdateTodoRequest(@NotBlank(message = "title must not be blank") String title,
                                boolean completed) {
}

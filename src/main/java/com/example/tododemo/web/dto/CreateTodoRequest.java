package com.example.tododemo.web.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * Request body for creating a todo.
 */
public record CreateTodoRequest(@NotBlank(message = "title must not be blank") String title) {
}

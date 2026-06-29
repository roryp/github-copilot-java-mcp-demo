package com.example.tododemo.service;

import com.example.tododemo.exception.TodoNotFoundException;
import com.example.tododemo.model.Todo;
import com.example.tododemo.repository.TodoRepository;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.Instant;
import java.util.List;

/**
 * Business logic for managing todos.
 *
 * <p>Shared by both the REST controller ({@code TodoController}) and the MCP
 * tools ({@code TodoTools}) so the HTTP API and the MCP tools always operate on
 * exactly the same data and rules.
 */
@Service
public class TodoService {

    private final TodoRepository repository;

    public TodoService(TodoRepository repository) {
        this.repository = repository;
    }

    public List<Todo> list() {
        return repository.findAll();
    }

    public Todo get(Long id) {
        return repository.findById(id).orElseThrow(() -> new TodoNotFoundException(id));
    }

    public Todo add(String title) {
        Todo todo = new Todo(null, requireTitle(title), false, Instant.now());
        return repository.save(todo);
    }

    public Todo update(Long id, String title, boolean completed) {
        Todo todo = get(id);
        todo.setTitle(requireTitle(title));
        todo.setCompleted(completed);
        return repository.save(todo);
    }

    public Todo setCompleted(Long id, boolean completed) {
        Todo todo = get(id);
        todo.setCompleted(completed);
        return repository.save(todo);
    }

    public void delete(Long id) {
        if (!repository.deleteById(id)) {
            throw new TodoNotFoundException(id);
        }
    }

    private String requireTitle(String title) {
        if (!StringUtils.hasText(title)) {
            throw new IllegalArgumentException("Todo title must not be blank");
        }
        return title.trim();
    }
}

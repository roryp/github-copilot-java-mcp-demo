package com.example.tododemo.web;

import com.example.tododemo.model.Todo;
import com.example.tododemo.service.TodoService;
import com.example.tododemo.web.dto.CreateTodoRequest;
import com.example.tododemo.web.dto.UpdateTodoRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

/**
 * REST API for todos.
 *
 * <p>These endpoints are the public HTTP surface of the application. The same
 * operations are also exposed as MCP tools in
 * {@code com.example.tododemo.mcp.TodoTools}.
 */
@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final TodoService service;

    public TodoController(TodoService service) {
        this.service = service;
    }

    @GetMapping
    public List<Todo> list() {
        return service.list();
    }

    @GetMapping("/{id}")
    public Todo get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<Todo> create(@Valid @RequestBody CreateTodoRequest request,
                                       UriComponentsBuilder uriBuilder) {
        Todo created = service.add(request.title());
        URI location = uriBuilder.path("/api/todos/{id}").buildAndExpand(created.getId()).toUri();
        return ResponseEntity.created(location).body(created);
    }

    @PutMapping("/{id}")
    public Todo update(@PathVariable Long id, @Valid @RequestBody UpdateTodoRequest request) {
        return service.update(id, request.title(), request.completed());
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}

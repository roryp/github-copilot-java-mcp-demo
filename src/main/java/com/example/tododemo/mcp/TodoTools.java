package com.example.tododemo.mcp;

import com.example.tododemo.model.Todo;
import com.example.tododemo.service.TodoService;
import org.springframework.ai.mcp.annotation.McpTool;
import org.springframework.ai.mcp.annotation.McpToolParam;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Exposes the todo operations as Model Context Protocol (MCP) tools.
 *
 * <p>Each {@link McpTool}-annotated method becomes a tool that any MCP client
 * (for example, GitHub Copilot in VS Code) can discover and invoke. The methods
 * delegate to the same {@link TodoService} used by the REST controller, so the
 * REST API and the MCP tools always act on identical data.
 *
 * <p>The Spring AI MCP server auto-configuration scans for these annotations by
 * default ({@code spring.ai.mcp.server.annotation-scanner.enabled=true}) and
 * publishes them over the Streamable-HTTP endpoint at {@code /mcp}.
 */
@Component
public class TodoTools {

    private final TodoService service;

    public TodoTools(TodoService service) {
        this.service = service;
    }

    @McpTool(name = "list_todos",
            description = "List all todo items, including their id, title and completion status.")
    public List<Todo> listTodos() {
        return service.list();
    }

    @McpTool(name = "get_todo", description = "Get a single todo item by its id.")
    public Todo getTodo(
            @McpToolParam(description = "The id of the todo to fetch", required = true) long id) {
        return service.get(id);
    }

    @McpTool(name = "add_todo", description = "Create a new todo item with the given title.")
    public Todo addTodo(
            @McpToolParam(description = "The title of the new todo", required = true) String title) {
        return service.add(title);
    }

    @McpTool(name = "complete_todo", description = "Mark the todo with the given id as completed.")
    public Todo completeTodo(
            @McpToolParam(description = "The id of the todo to mark complete", required = true) long id) {
        return service.setCompleted(id, true);
    }

    @McpTool(name = "delete_todo", description = "Delete the todo with the given id.")
    public String deleteTodo(
            @McpToolParam(description = "The id of the todo to delete", required = true) long id) {
        service.delete(id);
        return "Deleted todo " + id;
    }
}

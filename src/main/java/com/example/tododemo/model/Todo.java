package com.example.tododemo.model;

import java.time.Instant;

/**
 * A single todo item.
 *
 * <p>Kept as a mutable POJO so the in-memory store can update the completion
 * status and title in place. Jackson serializes this directly to/from JSON for
 * both the REST API and the MCP tool responses.
 */
public class Todo {

    private Long id;
    private String title;
    private boolean completed;
    private Instant createdAt;

    public Todo() {
    }

    public Todo(Long id, String title, boolean completed, Instant createdAt) {
        this.id = id;
        this.title = title;
        this.completed = completed;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }
}

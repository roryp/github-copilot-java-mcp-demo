package com.example.tododemo.repository;

import com.example.tododemo.model.Todo;
import org.springframework.stereotype.Repository;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Thread-safe in-memory store for {@link Todo} items.
 *
 * <p>Intentionally not backed by a database. This keeps the demo self-contained
 * and gives the GitHub Copilot cloud-agent step (step 5) a natural, well-scoped
 * enhancement to make: replace this with Spring Data JPA + an H2 database.
 */
@Repository
public class TodoRepository {

    private final ConcurrentMap<Long, Todo> store = new ConcurrentHashMap<>();
    private final AtomicLong sequence = new AtomicLong();

    public List<Todo> findAll() {
        return store.values().stream()
                .sorted(Comparator.comparing(Todo::getId))
                .toList();
    }

    public Optional<Todo> findById(Long id) {
        return Optional.ofNullable(store.get(id));
    }

    public Todo save(Todo todo) {
        if (todo.getId() == null) {
            todo.setId(sequence.incrementAndGet());
        }
        store.put(todo.getId(), todo);
        return todo;
    }

    public boolean deleteById(Long id) {
        return store.remove(id) != null;
    }

    public long count() {
        return store.size();
    }
}

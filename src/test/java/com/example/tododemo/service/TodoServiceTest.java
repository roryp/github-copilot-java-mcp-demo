package com.example.tododemo.service;

import com.example.tododemo.exception.TodoNotFoundException;
import com.example.tododemo.model.Todo;
import com.example.tododemo.repository.TodoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Fast, plain-JUnit unit tests for {@link TodoService} (no Spring context).
 */
class TodoServiceTest {

    private TodoService service;

    @BeforeEach
    void setUp() {
        service = new TodoService(new TodoRepository());
    }

    @Test
    void addAssignsIdAndStoresTodo() {
        Todo todo = service.add("Write the demo guide");

        assertThat(todo.getId()).isNotNull();
        assertThat(todo.getTitle()).isEqualTo("Write the demo guide");
        assertThat(todo.isCompleted()).isFalse();
        assertThat(service.list()).hasSize(1);
    }

    @Test
    void completeMarksTodoCompleted() {
        Todo todo = service.add("Ship it");

        Todo completed = service.setCompleted(todo.getId(), true);

        assertThat(completed.isCompleted()).isTrue();
    }

    @Test
    void updateChangesTitleAndStatus() {
        Todo todo = service.add("Old title");

        Todo updated = service.update(todo.getId(), "New title", true);

        assertThat(updated.getTitle()).isEqualTo("New title");
        assertThat(updated.isCompleted()).isTrue();
    }

    @Test
    void getMissingTodoThrows() {
        assertThatThrownBy(() -> service.get(999L))
                .isInstanceOf(TodoNotFoundException.class);
    }

    @Test
    void deleteRemovesTodo() {
        Todo todo = service.add("Remove me");

        service.delete(todo.getId());

        assertThat(service.list()).isEmpty();
    }

    @Test
    void addBlankTitleIsRejected() {
        assertThatThrownBy(() -> service.add("   "))
                .isInstanceOf(IllegalArgumentException.class);
    }
}

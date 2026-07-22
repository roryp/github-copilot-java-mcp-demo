# Add persistent todos and due dates

The Todo app currently stores data in memory, so all todos are lost when the
application restarts. Update the app to persist todos and support optional due
dates.

## Requirements

- Replace the in-memory repository with Spring Data JPA and a file-based H2
  database so todos survive application restarts.
- Add an optional `dueDate` field to `Todo`.
- Update the web form and Todo list to accept and display due dates.
- Visually identify overdue todos in the web UI.
- Add an MCP tool named `set_due_date`.
- Update `list_todos` to support `all`, `today`, and `overdue` filters.
- Keep the existing web and MCP functionality working.
- Add or update tests for persistence, due dates, and filtering.

## Done when

- `./mvnw clean package` passes.
- A todo and its due date are still present after restarting the application.

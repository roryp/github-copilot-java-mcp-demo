# Copilot coding agent — ready-to-assign issue

> For a new repository or fork, copy everything under the line into a **new
> GitHub issue**, then assign it to **@copilot** (or use **"Delegate to coding
> agent"** from the GitHub Pull Requests view in VS Code). This requires the
> coding agent to be enabled and write access to the repository. The recorded
> demo already has a prepared issue and draft pull request, so do not create a
> duplicate when recording it. See the [README](../README.md) for the workflow.

---

### Title

Add persistent storage (Spring Data JPA + H2) and a `dueDate` field with filtering

### Background

`springboot-mcp-demo` is a Spring Boot 4.1 / Java 25 Todo app. Today todos are
kept in a **non-persistent, in-memory** store (`TodoRepository` backed by a
`ConcurrentHashMap`), so everything is lost on restart. The web UI
(`TodoController`) and MCP tools (`TodoTools`) both delegate to `TodoService`.

We want todos to survive restarts and to support an optional **due date** so the
list can be filtered to "what's due".

### Acceptance criteria

- [ ] Todos are persisted with **Spring Data JPA** and an **H2** database
      (file-based so data survives a restart).
- [ ] `Todo` gains an optional `dueDate` (`LocalDate`, nullable) field, returned
      by the MCP tools.
- [ ] The web form accepts an optional due date.
- [ ] The web UI shows each todo's due date and visually flags overdue items.
- [ ] Add an MCP tool `set_due_date(id, dueDate)`; `list_todos` accepts an
      optional `filter` argument with `today`, `overdue`, or `all`.
- [ ] Existing unit/integration tests still pass; add tests for persistence,
      the `dueDate` field, and the filter.

### Technical guidance

- Add `spring-boot-starter-data-jpa` and the `com.h2database:h2` runtime
  dependency to `pom.xml`.
- Convert `Todo` into a JPA `@Entity` and add `dueDate`. Replace the hand-rolled
      `TodoRepository` with a Spring Data
  `JpaRepository<Todo, Long>`; keep `TodoService` as the single shared entry
      point for the web UI and MCP tools.
- Configure H2 in `application.properties`
  (`spring.datasource.url=jdbc:h2:file:./data/tododb`,
  `spring.jpa.hibernate.ddl-auto=update`). Optionally enable the H2 console.
- Keep the MCP protocol on `STREAMABLE` and the `/mcp` endpoint unchanged.

### Out of scope

- Authentication / multi-user support.
- Switching away from H2 to an external database.
- Changing the MCP transport or endpoint path.

### Verification

- `./mvnw clean package` passes.
- `./mvnw spring-boot:run`, create a todo with a due date, restart the app, and
  confirm it is still present.
- `scripts/mcp-smoke-test.ps1` passes with the exact six-tool contract:
      `-ExpectedTools add_todo,complete_todo,delete_todo,get_todo,list_todos,set_due_date`.

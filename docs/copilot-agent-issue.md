# Copilot coding agent — ready-to-assign issue

> Copy everything under the line into a **new GitHub issue**, then assign it to
> **@copilot** (or use **"Delegate to coding agent"** from the GitHub Pull
> Requests view in VS Code). The agent will open a pull request you can review.
> See Step 5 of the [README](../README.md) for the full workflow.

---

### Title

Add persistent storage (Spring Data JPA + H2) and a `dueDate` field with filtering

### Background

`springboot-mcp-demo` is a Spring Boot 4.1 / Java 25 Todo API. Today todos are
kept in a **non-persistent, in-memory** store (`TodoRepository` backed by a
`ConcurrentHashMap`), so everything is lost on restart. The same operations are
exposed both as REST endpoints (`TodoController`) and as MCP tools (`TodoTools`),
both delegating to `TodoService`.

We want todos to survive restarts and to support an optional **due date** so the
list can be filtered to "what's due".

### Acceptance criteria

- [ ] Todos are persisted with **Spring Data JPA** and an **H2** database
      (file-based so data survives a restart).
- [ ] `Todo` gains an optional `dueDate` (`LocalDate`, nullable) field, returned
      by the REST API and the MCP tools.
- [ ] `POST /api/todos` and `PUT /api/todos/{id}` accept an optional `dueDate`.
- [ ] New endpoint `GET /api/todos?due=today|overdue|all` filters accordingly
      (`all` is the default and preserves current behaviour).
- [ ] New MCP tool `set_due_date(id, dueDate)` and the existing tools continue to
      work; `list_todos` accepts an optional `filter` argument matching the REST
      `due` values.
- [ ] The web UI (`static/index.html`) shows each todo's due date and visually
      flags overdue items.
- [ ] Existing unit/integration tests still pass; add tests for persistence,
      the `dueDate` field, and the filter.

### Technical guidance

- Add `spring-boot-starter-data-jpa` and the `com.h2database:h2` runtime
  dependency to `pom.xml`.
- Convert `Todo` into a JPA `@Entity` (keep the existing JSON shape; add
  `dueDate`). Replace the hand-rolled `TodoRepository` with a Spring Data
  `JpaRepository<Todo, Long>`; keep `TodoService` as the single shared entry
  point for both `TodoController` and `TodoTools`.
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
- `scripts/mcp-smoke-test.ps1` still lists the tools (now including
  `set_due_date`).

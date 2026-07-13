# Demo Recording Script — Java Spring Boot + MCP + Copilot

**Repo:** https://github.com/roryp/vscode-learn

## Episode 1 of 4 — Build and debug your first Spring Boot app

### Intro — Talking head (~15s)

> First of four short videos where we take one Spring Boot app all the way — from an empty editor to something GitHub Copilot can drive and even improve. People think a Java web app means endless setup and clunky debugging — it really doesn't anymore. In this one I'll scaffold the app, run it, then set a breakpoint and watch its memory live, all in VS Code. So let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

### Demo — Build & run

| Where | Do | Say |
|-------|----|-----|
| VS Code — Extensions view (`Ctrl+Shift+X`) | Search **"Extension Pack for Java"** and install. Then install a **JDK 25** (Ctrl+Shift+P → *Java: Install New JDK*, or show it already installed). | "Let's start from nothing. First I install the Extension Pack for Java — that gives me language support, debugging, Maven, and testing in one bundle — plus a JDK to compile and run." |
| Extensions view | Search **"Spring Boot Extension Pack"** (Spring Boot Tools, Dashboard, Initializr) and install. | "Next, the Spring Boot Extension Pack. This adds the Spring Initializr, the Spring Boot Dashboard, and smart editing for Spring config." |
| Command Palette (`Ctrl+Shift+P`) | Run **"Spring Initializr: Create a Maven Project"**. Choose: Spring Boot 4.1.x → Java → group `com.example` → artifact `springboot-mcp-demo` → Java 25 → dependencies **Spring Web**, **Thymeleaf**, **Actuator**. | "The Initializr scaffolds a project right inside VS Code — no browser needed. I pick Web, Thymeleaf, and Actuator to get started." |
| Explorer + editor | Open the finished version of this project (the one I prepared earlier) from the repo https://github.com/roryp/vscode-learn. Show `TodoController`, `TodoService`, `TodoRepository`, `Todo`, and `templates/index.html`. | "To save time, here's one I built earlier with those exact choices — same structure. One `TodoService` holds the logic; a Thymeleaf page and controller give us a simple web UI backed by an in-memory store." |
| Terminal | `.\mvnw.cmd spring-boot:run` — then open http://localhost:8080. Add a todo, toggle it, delete it. | "Build and run with the Maven wrapper. There's our Todo app — add, complete, delete. Classic Spring Boot web app." |

**The running Todo web app:**

![Todo web app](../docs/images/01-web-app.png)

**The Spring Initializr version picker — auto-captured by `scripts/capture-initializr.ps1`:**

![Spring Initializr version picker](../docs/images/00-initializr.png)

### Demo — Debug & watch memory

| Where | Do | Say |
|-------|----|-----|
| Editor — `TodoController.java` | Click the gutter to set a **breakpoint** on the `addForm` method (the `service.add(title)` line). | "Let's debug. I'll drop a breakpoint where a new todo gets created." |
| Spring Boot Dashboard / Run view | Start the app with **F5** (Debug). In the browser add a todo to hit the breakpoint. | "Launch in debug mode with F5, add a todo, and execution pauses right on our line." |
| Debug toolbar + Variables panel | Step over (`F10`), inspect `title` and the returned `Todo` in **Variables**. Continue (`F5`). | "I can step through, inspect the incoming title and the saved Todo — full breakpoint debugging, no extra setup." |
| Spring Boot Dashboard → running app → **Memory** view (or Actuator) | Open the **Actuator / Memory** view; show heap/non-heap live gauges. Also hit http://localhost:8080/actuator/health. | "Because we added Actuator, VS Code gives me a live Memory view and health endpoint — real-time JVM insight while the app runs." |

**Actuator health endpoint (all systems UP):**

![Actuator health](../docs/images/02-actuator-health.png)

**Paused at the breakpoint — Variables panel and live inline values (auto-captured by `scripts/capture-window.ps1`):**

![Debug breakpoint](../docs/images/04-debug-breakpoint.png)

**Spring Boot Dashboard Memory view — live heap gauge (auto-captured by `scripts/capture-window.ps1`):**

![Memory view](../docs/images/05-memory-view.png)

### Outro — Talking head (~15s)

> So that's a Spring Boot app built, running, and fully debuggable — breakpoints and a live memory view, no print statements, all from VS Code. The whole project's on GitHub, linked below. Comment your favorite debugging trick. Next video's the fun one — I'll turn this app into tools GitHub Copilot can actually call.

---

## Episode 2 of 4 — Expose your endpoints to Copilot with MCP

### Intro — Talking head (~15s)

> We've got our running Spring Boot app — all in the repo if you're just joining. Everyone's talking about giving AI agents tools, but hardly anyone exposes their own app that way. I'll turn my endpoints into MCP tools Copilot can call directly. So let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `pom.xml` | Show the dependency **`spring-ai-starter-mcp-server-webmvc`** and the `spring-ai-bom` 2.0.0. | "To turn my app into tools an AI agent can call, I add one dependency: the Spring AI MCP server." |
| `mcp/TodoTools.java` | Walk through the `@McpTool` / `@McpToolParam` annotations on `addTodo`, `listTodos`, etc. Point out they just delegate to `TodoService`. | "Each method gets an `@McpTool` annotation with a name and description. They reuse the exact same service the web UI uses — no duplicated logic. Five tools: list, get, add, complete, delete." |
| `application.properties` | Highlight `spring.ai.mcp.server.protocol=STREAMABLE`. | "One critical setting: `protocol=STREAMABLE`. The WebMVC starter defaults to the old SSE transport — without this, `/mcp` returns 404." |
| Terminal (restart app) | `.\mvnw.cmd spring-boot:run` and point to the log line **`Registered tools: 5`**. | "Restart, and the log confirms all five tools are registered and served at `/mcp`." |
| `.vscode/mcp.json` | Show the `todo-mcp` HTTP server entry; click the **Start** code-lens. | "This file points VS Code at my server over HTTP. I start it right from the editor." |
| Copilot Chat (Agent mode) | Enable the `todo-mcp` tools. Ask: *"Use the todo-mcp tools to add a todo called 'Email the stakeholders', then list all todos."* Refresh http://localhost:8080. | "Now in Agent mode I ask Copilot to add a todo and list them. It calls my Java code as tools — and the new item shows up in the web UI. Same data, driven by AI." |

**Proof it works — a todo created *through MCP* appears in the web UI** (last row):

![Todo added via MCP](../docs/images/03-mcp-added-todo.png)

**Copilot Chat calling the `todo-mcp` tools — the `add_todo` call and its JSON result:**

![Copilot Chat todo-mcp tool call](../docs/images/06-copilot-mcp-chat.png)

### Outro — Talking head (~15s)

> And there it is — Copilot adding a todo by calling my own Java code, right in the web UI. One dependency, one setting. MCP docs linked below. Comment what you'd expose as a tool. Next up, I'll let Copilot test this whole flow with Playwright.

---

## Episode 3 of 4 — Let Copilot test it with Playwright

### Intro — Talking head (~15s)

> Last video I gave Copilot tools to drive my app through MCP — all in the repo if you missed it. UI tests are the thing everyone skips, so what if you didn't write them at all? I'll have Copilot drive a real browser with Playwright. Let's get into it.

**Do:** End on “let's get into it,” then cut to screen share.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `templates/index.html` | Point out the `data-testid` hooks: `new-todo-input`, `add-todo`, `todo-item`, `delete-todo`. | "I added stable test IDs to the UI so automation has reliable selectors." |
| Copilot Chat (Agent mode, Playwright MCP) | Ask Copilot to use the **Playwright** tools to open http://localhost:8080, add a todo, complete it, and delete it. | "Using the Playwright MCP server, I let Copilot drive a real browser — add, complete, delete — end to end, no test code written by hand." |
| Browser window (Playwright) | Watch the automated browser perform the add → complete → delete flow. | "There it goes: filling the input, clicking add, toggling, deleting — a full UI smoke test." |
| Terminal | Run the JSON-RPC smoke test: `powershell -ExecutionPolicy Bypass -File scripts\mcp-smoke-test.ps1` (app running). Show `tools/list` and `add_todo` succeeding. Also run `.\mvnw.cmd test`. | "For a scripted check, this smoke test does the raw MCP handshake — initialize, list tools, call add_todo — the same protocol Copilot uses. And `mvnw test` covers the service, web UI, and MCP context." |

**Actual smoke-test output (verified):**

```text
1. initialize  -> server: todo-mcp-server v1.0.0  (session ...)
2. notifications/initialized -> sent
3. tools/list  -> 5 tools: add_todo, complete_todo, delete_todo, get_todo, list_todos
4. tools/call add_todo -> {"id":4,"title":"Created through the MCP add_todo tool","completed":false,...}

MCP smoke test PASSED.
```

**Playwright driving the UI mid-run — auto-captured by `scripts/screenshots/capture.mjs`:**

![Playwright run](../docs/images/07-playwright-run.png)

### Outro — Talking head (~15s)

> So that's an end-to-end UI test I never wrote, plus a scripted MCP check — both green. The smoke-test script's in the repo. Comment if you're using Playwright with Copilot yet. Last episode, I'll hand a whole new feature to the Copilot cloud agent and let it open the PR.

---

## Episode 4 of 4 — Hand a feature to the Copilot cloud agent

### Intro — Talking head (~15s)

> Last of four videos taking one Spring Boot app from empty editor to AI-ready — all in the repo if you're just joining. Here's the part most people haven't tried: handing real work to an AI agent and getting a pull request back. So let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `docs/copilot-agent-issue.md` | Open it; show the ready-to-assign task: add **Spring Data JPA + H2** persistence and a **`dueDate`** field with filtering. | "Todos are in memory on purpose. Here's a ready-to-go issue asking for real persistence and a due-date feature." |
| GitHub — new issue | Paste the issue content, create it, and **assign it to @copilot** (or use *Delegate to coding agent* in the GitHub Pull Requests view). | "I assign this to the Copilot coding agent — it works asynchronously in the cloud, just like a teammate." |
| GitHub Pull Requests view (VS Code) | Wait for the agent to open a **pull request**; open it and review the diff (new JPA entity, repository, `dueDate`, tests). | "A few minutes later the agent opens a pull request — JPA entity, Spring Data repository, the new field, and updated tests." |
| PR review | Skim the changes, leave a comment or approve, then merge. | "I review, comment if needed, and merge. From a web app, to MCP tools, to an AI-built feature — all inside VS Code." |

**The issue assigned to the Copilot coding agent (@copilot) — auto-captured by `scripts/screenshots/capture.mjs`:**

![Issue assigned to Copilot](../docs/images/08-issue-assigned.png)

**The pull request the Copilot agent opened — its diff (13 files: new JPA entity, repository, `dueDate`, tests) — auto-captured by `scripts/screenshots/capture.mjs`:**

![Agent pull request](../docs/images/09-agent-pr.png)

### Outro — Talking head (~20s)

> And that's a full feature — persistence and a due-date field — delivered as a pull request I just review and merge. Over four videos we went from an empty editor to a running app, exposed it to Copilot with MCP, tested it, and let the cloud agent extend it. Want to try it? Grab the extensions, turn on Copilot and the coding agent, and clone the repo — it's all linked below. Thanks for watching.

**Do:** Hold on the repo URL (lower-third or on-screen text `github.com/roryp/vscode-learn`), then fade out.

---

## Resources (video descriptions / hand-off)

- **Demo repo:** https://github.com/roryp/vscode-learn
- **Extension Pack for Java** (Microsoft): https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack
- **Spring Boot Extension Pack:** search “Spring Boot Extension Pack” in the VS Code Marketplace
- **Java in VS Code:** https://code.visualstudio.com/docs/languages/java
- **Spring Boot Actuator:** https://docs.spring.io/spring-boot/
- **Spring AI (MCP server):** https://docs.spring.io/spring-ai/reference/
- **Model Context Protocol:** https://modelcontextprotocol.io
- **MCP in VS Code:** https://code.visualstudio.com/docs/copilot/chat/mcp-servers
- **Playwright MCP:** https://github.com/microsoft/playwright-mcp
- **GitHub Copilot coding agent:** https://docs.github.com/en/copilot

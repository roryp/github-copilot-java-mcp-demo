# Demo Recording Script — Java Spring Boot + Model Context Protocol (MCP) + Copilot

**Demo source:** Prepared local copy. Add the finished sample repository link only after publication approval.

> **Publication check:** Review every screenshot and screen recording for repository names, local paths, account names, notifications, and other identifying information. Redact or replace any exposed details before publishing.

## Episode 1 of 4 — Build and debug your first Spring Boot app

### Intro — Talking head (~50s)

> Welcome to this introduction to Java and Spring Boot in Visual Studio Code.
>
> Java is one of the world’s most widely used programming languages. Organizations of every size use it for enterprise applications, financial systems, cloud services, and Android apps. Its reliability, performance, and large ecosystem have made it a popular choice for decades.
>
> Spring Boot is one of the most popular Java frameworks. It handles much of the setup and configuration needed for modern applications, so developers can focus on application code instead of boilerplate.
>
> Whether you’re new to Java or already have some experience, the goal is to get you up and running with Java development in Visual Studio Code. I’ll install the Java and Spring tooling and use Spring Initializr to create a starter project. Then I’ll clone and run the finished sample, follow a request through the code with the debugger, and monitor the app’s health and memory. Let’s jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

### Demo — Set up, build & run

**Before recording:** Have Java 25 installed, open the completed sample in VS Code, have the two Maven commands ready to paste, and prepare a browser tab for http://localhost:8080. If the extension packs are already installed, show their **Installed** state instead of changing the setup during the take.

**Pacing:** Speak each line before performing its action. Leave Java import, tests, and startup logs silent.

| Where | Do | Say |
|-------|----|-----|
| VS Code — Extensions view (`Ctrl+Shift+X`) | Search **"Extension Pack for Java"**. Show that it is installed, or install it on a clean setup. | "First, I need to install the Extension Pack for Java. It adds Java language support, debugging, Maven, and testing." |
| Command Palette (`Ctrl+Shift+P`) | Run **"Java: Install New JDK"**, briefly show the installation options, then press `Esc`. | "I already have Java 25 installed. If you need a JDK, open the Command Palette and run Java: Install New JDK." |
| Extensions view | Search **"Spring Boot Extension Pack"**. Show that it is installed, or install it on a clean setup. | "Next, I'll install the Spring Boot Extension Pack. It adds Spring Initializr, the Spring Boot Dashboard, and Spring configuration support." |
| Command Palette (`Ctrl+Shift+P`) | Run **"Spring Initializr: Create a Maven Project"** and stop at the first picker. | "With the tooling ready, I'll use Spring Initializr to show how I created this Maven project." |
| Spring Initializr prompts | Choose Spring Boot 4.1.0 → Java → group `com.example` → artifact `springboot-mcp-demo` → **Jar** → Java 25. | "I'll use Spring Boot 4.1 and Java 25 for this sample." |
| Dependency picker | Add **Spring Web**, **Thymeleaf**, **Actuator**, and **Model Context Protocol Server**. Pause with all four selected, then press `Esc` to cancel the wizard before it generates a project. | "These are the dependencies I used to create the sample: Spring Web, Thymeleaf, Actuator, and the MCP server starter that I'll use later in this series. At this point, Initializr has everything it needs." |
| Explorer | With the wizard closed, expand the Todo package and `templates` folder in the workspace already on screen. | "I've cloned the completed sample from the link in the description ahead of time, and it's already open here in VS Code. It follows the structure Initializr set up and adds the Todo code and web page." |
| `SpringbootMcpDemoApplication.java` | Show `main` and `@SpringBootApplication`. | "This is the entry point. Spring Boot starts the application, finds the Spring classes in this package, creates them, and wires their dependencies together." |
| `Todo.java` → `TodoRepository.java` → `TodoService.java` | Briefly show each class and its annotation or constructor. | "The model defines a Todo. The repository stores Todos in memory, and the service holds the application operations. Spring injects the repository into the service through its constructor." |
| `templates/index.html` → `TodoController.java` | Show the add form action, then the matching controller method and its service call. | "The frontend submits forms to the web controller. The controller calls the service, then reloads the page with the latest Todos for Thymeleaf to render." |
| Terminal | Paste `.\mvnw.cmd test`, press `Enter`, and wait for **`BUILD SUCCESS`**. **Do not narrate while the tests run.** | "Before I start the app, I'll compile the project and run its tests with the Maven wrapper." |
| Terminal | After **`BUILD SUCCESS`**, paste `.\mvnw.cmd spring-boot:run`, press `Enter`, and wait for **`Started SpringbootMcpDemoApplication`**. Non-fatal Spring AI `BeanPostProcessorChecker` warnings may appear first. **Do not narrate while the logs scroll.** | "The tests pass, so now I'll start Spring Boot." |
| Terminal → browser | Point to the **Started** message, then open http://localhost:8080. | "The app is running on port 8080. I'll open it in the browser." |
| Browser | Add a todo called **Prepare the demo**, mark it complete, and delete it. | "I'll add a Todo, mark it complete, and delete it. That confirms the basic flow works." |
| Terminal | Return to the app terminal and press `Ctrl+C`. | "I'll stop this run here. Next, I'll restart the same app with the debugger attached." |

**The Spring Initializr version picker:**

![Spring Initializr version picker](../docs/images/00-initializr.png)

**The running Todo web app:**

![Todo web app](../docs/images/01-web-app.png)

### Demo — Debug & watch memory

| Where | Do | Say |
|-------|----|-----|
| Editor — `TodoController.java` | Click the gutter to set a **breakpoint** on the `addForm` method (the `service.add(title)` line). | "Now that I've confirmed the app works, I want to see what happens when I click Add. I'll return to the controller and set a breakpoint where it hands the new Todo to the service." |
| Spring Boot Dashboard | Use the app's **Debug** action and wait for it to start. | "Because I stopped the terminal run, port 8080 is free. The Dashboard can launch the same application with the debugger attached." |
| Spring Boot Dashboard → `TodoController.java` | Wait for the live connection, then show the running status and controls. Point out **Beans**, **Endpoint Mappings**, **Properties**, and **Memory**, then the gray URL hints above the controller mappings. | "The Dashboard now exposes live beans, endpoint mappings, properties, and memory. Spring Tools also adds gray, clickable URLs beside the controller mappings." |
| Editor → browser | Click the root URL, then add a todo to hit the breakpoint. | "I'll use the root URL to open the app. Submitting a Todo brings execution back to the breakpoint." |
| Debug toolbar + Variables panel | Expand **Local** and inspect `title`, then step into `TodoService.add` (`F11`). Step over the `Todo todo = ...` line (`F10`) and inspect the new `todo` local. Before recording, close Chat and hide any terminal output that contains local paths or account details. | "The controller shows me the title that came from the form. I can step into the service, execute the object creation, and inspect the new Todo before the repository saves it." |
| Debug toolbar + browser | Continue (`F5`) and show the new todo in the browser. Leave the debug session running. | "I'll continue the request and the browser updates with the new item. I'll keep the app running under the debugger, because the next step is to inspect its runtime health." |
| Browser | Open http://localhost:8080/actuator/health and show the `UP` status. | "The user flow is working, and Actuator gives me a direct health check as well. This endpoint reports that the application is up and ready to serve requests." |
| Spring Boot Dashboard → running app → **Memory** view | Open the **Memory** view and show the live heap and non-heap gauges. | "That same Actuator integration also lights up the Memory view in VS Code, where I can watch the Java Virtual Machine's heap and non-heap usage while the app runs." |
| Debug toolbar | Stop the debug session (`Shift+F5`) before ending the episode. | "That takes me from a normal run into the code and then out to the app's runtime state. I'll stop the debug session now so port 8080 is free for the next run." |

**Actuator health summary (all systems UP; local filesystem details removed):**

![Actuator health](../docs/images/02-actuator-health.png)

**Spring Boot Dashboard Memory view — live heap gauge:**

![Memory view](../docs/images/05-memory-view.png)

### Outro — Talking head (~20s)

> And there it is. I installed the Java and Spring extensions and used Spring Initializr to create a starter project. Then I cloned and ran the finished sample, followed a request through the code with the debugger, and monitored the app’s health and memory. That took me from a new Java setup to understanding what a Spring Boot app is doing while it runs. What would you build first with Java and Spring Boot? Let me know in the comments. Thanks for watching, and happy building.

---

## Episode 2 of 4 — Expose your endpoints to Copilot with the Model Context Protocol (MCP)

### Intro — Talking head (~20s)

> In this video, I'll show how a Spring Boot app becomes a set of tools GitHub Copilot can call directly in Visual Studio Code. I'll use Spring AI to expose the existing Java operations through the Model Context Protocol, or MCP, while keeping the web interface and Copilot connected to the same service. Let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

**Prerequisites:** Open the prepared app, sign in to GitHub Copilot Chat, and allow MCP tool use when VS Code prompts for trust or confirmation.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `pom.xml` | Show the dependency **`spring-ai-starter-mcp-server-webmvc`** and the `spring-ai-bom` 2.0.0. | "The MCP layer starts with the Spring AI MCP server dependency, with its version managed by the Spring AI Bill of Materials." |
| `mcp/TodoTools.java` | Walk through the `@McpTool` / `@McpToolParam` annotations on `addTodo`, `listTodos`, etc. Point out they just delegate to `TodoService`. | "Each method gets an `@McpTool` annotation with a name and description. They reuse the exact same service the web interface uses — no duplicated logic. Five tools: list, get, add, complete, delete." |
| `application.properties` | Highlight `spring.ai.mcp.server.protocol=STREAMABLE`. | "One critical setting: `protocol=STREAMABLE`. The Spring web starter defaults to the older Server-Sent Events transport — without this, `/mcp` returns 404." |
| Terminal | In a dedicated terminal, run `.\mvnw.cmd spring-boot:run` and wait for **`Registered tools: 5`**. Leave this terminal running. | "The startup log confirms that all five tools are registered and the app is serving the MCP endpoint." |
| `.vscode/mcp.json` | Show the `todo-mcp` entry for the running web endpoint. After the app is running, click its **Start** code-lens and approve the connection if prompted. | "This entry points VS Code at the running `/mcp` endpoint. Starting it here connects Copilot to the server; it does not launch the Java app itself." |
| Copilot Chat (Agent mode) | Enable the `todo-mcp` tools. Ask: *"Use the todo-mcp tools to add a todo called 'Email the stakeholders', then list all todos."* Refresh http://localhost:8080 and verify that exact title appears. | "Now I ask Copilot to add a todo and list the results. The tool call reaches the same Java service as the web interface, so the exact item created in chat appears in the browser." |
| Terminal | Stop the Spring Boot app with `Ctrl+C` after capturing the result. | "I'll stop the app here. Because the store is in memory, stopping it also clears the data." |

**Proof it works — a todo created *through MCP* appears in the web interface** (last row):

![Todo added via MCP](../docs/images/03-mcp-added-todo.png)

**Copilot Chat calling the `todo-mcp` tools — the `add_todo` call and its structured result:**

![Copilot Chat todo-mcp tool call](../docs/images/06-copilot-mcp-chat.png)

### Outro — Talking head (~20s)

> And there it is. I used Spring AI to expose the Todo operations as tools through the Model Context Protocol, connected those tools to GitHub Copilot in Visual Studio Code, and kept the web interface and Copilot using the same Java service. A Todo created through Copilot now appears in the web app straight away. What part of your own Java application would you turn into a Copilot tool? Let me know in the comments. Thanks for watching, and happy building.

---

## Episode 3 of 4 — Let Copilot test it with Playwright

### Intro — Talking head (~20s)

> In this video, I'll show how to test a Spring Boot web app in Visual Studio Code with GitHub Copilot and Playwright through the Model Context Protocol, or MCP. Passing unit tests don't prove the user interface works for a real user, so I'll have Copilot drive the app in a real browser and verify the experience end to end. Let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

**Prerequisites:** Install Node.js 18 or newer, use an installed Edge browser, sign in to GitHub Copilot Chat, and approve the Playwright MCP server and its tools when prompted.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `.vscode/mcp.json` | Show the `playwright` server entry, which runs `@playwright/mcp` through `npx` with Microsoft Edge. Click its **Start** code-lens. | "The workspace includes the Playwright MCP server configuration. It uses the installed Edge browser, so I don't need a separate browser download." |
| Terminal 1 | Run `.\mvnw.cmd spring-boot:run` and leave the app running on http://localhost:8080. | "I start the app in its own terminal and leave it running while the browser and protocol checks execute." |
| `templates/index.html` | Point out the `data-testid` hooks: `new-todo-input`, `add-todo`, `todo-item`, `delete-todo`. | "I added stable test identifiers to the page so automation has reliable selectors." |
| Copilot Chat (Agent mode, Playwright MCP) | Ask: *"Use the Playwright tools to open http://localhost:8080. Add a todo called 'Verify the browser flow', find that todo's row, complete it and verify it is checked, then delete it and verify it is gone."* | "Using the Playwright tools, Copilot drives a real browser through one deterministic user journey and verifies the result at each stage." |
| Browser window (Playwright) | Watch the automated browser perform the add → complete → delete flow. | "There it goes: filling the input, clicking add, toggling, deleting — a full browser smoke test." |
| Terminal 2 | While the app remains running in Terminal 1, run `powershell -ExecutionPolicy Bypass -File scripts\mcp-smoke-test.ps1`, then `.\mvnw.cmd test`. | "The smoke test verifies the MCP handshake, the exact tool set, and a real `add_todo` result. The Maven tests separately cover the service, web flow, and Spring context." |
| Terminals / `.vscode/mcp.json` | Stop the app with `Ctrl+C`, then stop the Playwright MCP server. | "I stop both processes here, leaving the workspace ready for another clean run." |

**Representative smoke-test output** (session and generated todo identifiers vary):

```text
1. initialize  -> server: todo-mcp-server v1.0.0  (session dd013c8a-bee0-4393-be7e-8e2fc99aac00)
2. notifications/initialized -> sent
3. tools/list  -> 5 tools: add_todo, complete_todo, delete_todo, get_todo, list_todos
4. tools/call add_todo -> {"id":1,"title":"Created through the MCP add_todo tool","completed":false,"createdAt":"2026-07-16T10:54:28.414002200Z"}

MCP smoke test PASSED.
```

**Illustrative browser state during a Playwright run; the live Copilot tool calls are shown during the demo:**

![Playwright run](../docs/images/07-playwright-run.png)

### Outro — Talking head (~20s)

> And there it is. I connected Playwright to GitHub Copilot through the Model Context Protocol and had Copilot test the Spring Boot app in a real browser. It added a Todo, completed it, deleted it, and verified each result. Combined with the unit and integration tests, that gives me confidence in both the code and the experience a user actually sees. What browser workflow would you ask Copilot to test in your own app? Let me know in the comments. Thanks for watching, and happy building.

---

## Episode 4 of 4 — Hand a feature to the Copilot cloud agent

### Intro — Talking head (~20s)

> In this video, I'll hand the GitHub Copilot coding agent a complete feature for a Spring Boot Todo app and review the pull request it creates in Visual Studio Code. The issue asks the agent to save todos in a database so they survive restarts and to add an optional due date. It also asks for updates to the tools exposed through the Model Context Protocol, or MCP, plus tests for the new behavior. Let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

**Prerequisites:** Use a GitHub account with Copilot coding agent enabled, write access to the demo repository, and the GitHub Pull Requests extension signed in to VS Code.

**Recording plan:** Assign the issue before recording and let the asynchronous agent finish. During the video, use the prepared issue and draft pull request—do not create a duplicate or wait live. Keep the pull request unmerged until Episodes 1–3 are recorded so their baseline remains reproducible.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `docs/copilot-agent-issue.md` | Open it; show the ready-to-assign task: add **Spring Data JPA** persistence with an **H2 database** and a **`dueDate`** field with filtering. | "Todos are in memory on purpose. This issue asks for an H2 database using Spring Data JPA. JPA stands for Java Persistence API, the standard interface used to map Java objects to database records. The issue also adds a due-date feature." |
| GitHub — prepared issue | Open the issue that was assigned to **@copilot** before recording. | "I assigned this scoped issue ahead of time because the coding agent works asynchronously in the cloud. That removes an unpredictable live wait from the demo." |
| GitHub Pull Requests view (VS Code) | Open the draft pull request after the implementation commit has arrived; update it with the current baseline, then review the 13-file feature diff, including the JPA entity, repository, `dueDate`, MCP changes, and tests. | "The agent opened a draft pull request and then completed the implementation. I first bring in the current baseline, then review the actual feature diff rather than assuming the first draft contains finished code." |
| Pull-request branch + Terminals | Check out the updated pull-request branch. Run `.\mvnw.cmd test`; start the app in one terminal; in another run `powershell -ExecutionPolicy Bypass -File scripts\mcp-smoke-test.ps1 -ExpectedTools add_todo,complete_todo,delete_todo,get_todo,list_todos,set_due_date`. Then create a todo with a due date, restart the app, and confirm it persists. | "Before I consider merging, I run the tests, verify the expanded six-tool MCP contract, and check the two key behaviors locally: due dates work and data survives a restart." |
| Pull request review | Review the results and leave comments if needed. Keep the pull request draft and unmerged during this recording; only mark it ready and merge after the review is complete and the baseline has been preserved. | "The agent produced the implementation, but the review, verification, and final merge decision still belong to me." |

**The prepared issue assigned to the Copilot coding agent (@copilot):**

![Issue assigned to Copilot](../docs/images/08-issue-assigned.png)

**The draft pull request the Copilot agent opened — its 13-file diff includes the JPA entity, repository, `dueDate`, and tests:**

![Agent pull request](../docs/images/09-agent-pr.png)

### Outro — Talking head (~30s)

> And that’s the feature done. The coding agent handled the implementation, created the tests, and opened the pull request, but I still reviewed the changes and decided what gets merged. That’s really the point: I can delegate the work without giving up control. Now I’m curious where you’d take it. What are you planning to build, and what questions do you still have? Tell me in the comments. Thanks for watching, and happy building.

**Do:** Hold on the reviewed draft pull request, then fade out.

---

## Resources (video descriptions / hand-off)

- **Demo source:** Add a repository link only after publication approval
- **Extension Pack for Java** (Microsoft): https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack
- **Spring Boot Extension Pack:** search “Spring Boot Extension Pack” in the VS Code Marketplace
- **Java in VS Code:** https://code.visualstudio.com/docs/languages/java
- **Spring Boot Actuator:** https://docs.spring.io/spring-boot/
- **Spring AI (Model Context Protocol server):** https://docs.spring.io/spring-ai/reference/
- **Model Context Protocol:** https://modelcontextprotocol.io
- **Model Context Protocol in Visual Studio Code:** https://code.visualstudio.com/docs/copilot/chat/mcp-servers
- **Playwright Model Context Protocol server:** https://github.com/microsoft/playwright-mcp
- **GitHub Copilot coding agent:** https://docs.github.com/en/copilot

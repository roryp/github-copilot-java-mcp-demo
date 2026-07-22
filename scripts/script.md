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
> Whether you’re new to Java or already have some experience, the goal is to get you up and running with Java development in Visual Studio Code. I’ll set up the Java and Spring tooling and use Spring Initializr to retrace how the starter project was configured. Then I’ll explore and run the finished sample, follow a request through the code with the debugger, and monitor the app’s health and memory. Let’s jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

### Demo — Set up, build & run

**Before recording:** Have Java 25 installed, open the completed sample in VS Code, make sure the Maven Explorer and Spring Boot Dashboard views are available, and prepare a browser tab for http://localhost:8080. If the extension packs are already installed, show their **Installed** state instead of changing the setup during the take.

**Pacing:** Speak each line before performing its action. Leave Java import, the Maven build, and application startup silent.

| Where | Do | Say |
|-------|----|-----|
| VS Code — Extensions view (`Ctrl+Shift+X`) | Search **"Extension Pack for Java"**. Show that it is installed, or install it on a clean setup. | "I'll start by making sure VS Code has the Java tooling I need. The Extension Pack for Java adds language support, debugging, Maven, and testing." |
| Command Palette (`Ctrl+Shift+P`) | Run **"Java: Install New JDK"**, briefly show the installation options, then press `Esc`. | "That tooling still needs a JDK. I already have Java 25 installed, but if you don't, open the Command Palette and run Java: Install New JDK." |
| Extensions view | Search **"Spring Boot Extension Pack"**. Show that it is installed, or install it on a clean setup. | "With Java in place, I'll make sure the Spring Boot Extension Pack is installed. It brings in Spring Initializr, the Spring Boot Dashboard, and Spring configuration support." |
| Command Palette (`Ctrl+Shift+P`) | Run **"Spring Initializr: Create a Maven Project"** and stop at the first picker. | "Now that the tooling is ready, I'll open Spring Initializr and retrace how I created this Maven project." |
| Spring Initializr prompts | Choose Spring Boot 4.1.0 → Java → group `com.example` → artifact `springboot-mcp-demo` → **Jar** → Java 25. | "For the project itself, I'll choose Spring Boot 4.1 and Java 25." |
| Dependency picker | Add **Spring Web**, **Thymeleaf**, **Actuator**, and **Model Context Protocol Server**. Pause with all four selected, then press `Esc` to cancel the wizard before it generates a project. | "Then I'll add Spring Web, Thymeleaf, Actuator, and Model Context Protocol Server. Together they cover the web page, runtime insights, and MCP support, and Initializr now has everything it needs." |
| Explorer | With the wizard closed, expand the Todo package and `templates` folder in the workspace already on screen. | "Rather than generate a second copy, I'll return to the completed sample I cloned ahead of time. It keeps the structure Initializr created and adds the Todo code and web page." |
| `SpringbootMcpDemoApplication.java` | Show `main` and `@SpringBootApplication`. | "I'll begin with the entry point. Spring Boot starts here, finds the Spring classes in this package, creates them, and wires their dependencies together." |
| `Todo.java` → `TodoRepository.java` → `TodoService.java` | Briefly show each class and its annotation or constructor. | "From that entry point, the application is organized into a few small pieces. The model defines a Todo, and the repository stores Todos in memory. The service provides the application operations, with Spring injecting the repository through its constructor." |
| `templates/index.html` → `TodoController.java` | Show the add form action, then the matching controller method and its service call. | "That service connects the page to the application logic. The frontend submits a form to the controller, the controller calls the service, and Thymeleaf renders the updated list when the page reloads." |
| Maven Explorer | Expand **springboot-mcp-demo → Lifecycle**, run **package**, and wait for **`BUILD SUCCESS`** in the Maven output. **Do not narrate while Maven builds and runs the tests.** | "Now that I've followed the main request path, I'll use Maven Explorer to compile the project, run its tests, and package it." |
| Spring Boot Dashboard | Find **springboot-mcp-demo**, select its **Run** action, and wait for the app to show as running. **Do not narrate while it starts.** | "With the build complete, I'll start the application from the Spring Boot Dashboard." |
| Spring Boot Dashboard → browser | Point to the running app in the Dashboard, then open http://localhost:8080. | "Once startup finishes, the Dashboard shows the app running on port 8080, so I'll open it in the browser." |
| Browser | Add a todo called **Prepare the demo**, mark it complete, and delete it. | "Here I'll add a Todo, mark it complete, and delete it to exercise the full flow I just traced through the code." |
| Spring Boot Dashboard | Use the app's **Stop** action. | "The basic flow works. I'll stop this run so I can restart the same application with the debugger attached." |

**The Spring Initializr version picker:**

![Spring Initializr version picker](../docs/images/00-initializr.png)

**The running Todo web app:**

![Todo web app](../docs/images/01-web-app.png)

### Demo — Debug & watch memory

| Where | Do | Say |
|-------|----|-----|
| Editor — `TodoController.java` | Click the gutter to set a **breakpoint** on the `addForm` method (the `service.add(title)` line). | "Before I restart the app, I'll return to the controller and set a breakpoint where the form submission passes the title to the service. That gives me a precise place to pause the next request." |
| Spring Boot Dashboard | Use the app's **Debug** action and wait for it to start. | "With the breakpoint in place, I'll launch the same application from the Dashboard with the debugger attached. Because the normal run is stopped, it can use port 8080 again." |
| Spring Boot Dashboard → `TodoController.java` | Wait for the live connection, then show the running status and controls. Point out **Beans**, **Endpoint Mappings**, **Properties**, and **Memory**, then the gray URL hints above the controller mappings. | "Once the debugger connects, the Dashboard exposes a live view of the application's beans, endpoint mappings, properties, and memory. In the editor, Spring Tools also turns the controller mappings into clickable URL hints." |
| Editor → browser | Click the root URL, then add a todo to hit the breakpoint. | "Those URL hints connect the code to the running routes. I'll open the root page from the controller, submit another Todo, and let the breakpoint catch that request." |
| Debug toolbar + Variables panel | Expand **Local** and inspect `title`, then step into `TodoService.add` (`F11`). Step over the `Todo todo = ...` line (`F10`) and inspect the new `todo` local. Before recording, close Chat and hide any terminal output that contains local paths or account details. | "When the request pauses, I can inspect the title exactly as the controller received it. Then I'll step into the service, run the line that creates the Todo, and inspect the object before it reaches the repository." |
| Debug toolbar + browser | Continue (`F5`) and show the new todo in the browser. Leave the debug session running. | "Now I've followed the request from the form into the service and watched the Todo object get created. I'll continue so the repository can save it, the controller can redirect, and the browser can render the updated list. I'll leave the debugger attached for the runtime checks." |
| Browser | Open http://localhost:8080/actuator/health and show the `UP` status. | "That completes the request path from browser input to rendered output. With the app still running, I'll check its runtime state next, starting with the Actuator health endpoint. A status of UP confirms that the application is healthy." |
| Spring Boot Dashboard → running app → **Memory** view | Open the **Memory** view and show the live memory information. | "Actuator gives me a point-in-time health check. For a live view, I'll return to the Dashboard and open Memory, where I can watch the application's memory use without stopping the debug session." |
| Debug toolbar | Stop the debug session (`Shift+F5`) before ending the episode. | "With the request traced and the runtime checks complete, I'll stop the debugger here. That closes the application and leaves port 8080 free." |

**Actuator health summary (all systems UP; local filesystem details removed):**

![Actuator health](../docs/images/02-actuator-health.png)

**Spring Boot Dashboard Memory view:**

![Memory view](../docs/images/05-memory-view.png)

### Outro — Talking head (~20s)

> And there it is. I set up the Java and Spring extensions and used Spring Initializr to retrace the starter configuration. Then I explored and ran the finished sample, followed a request through the code with the debugger, and monitored the app’s health and memory. That took me from a new Java setup to understanding what a Spring Boot app is doing while it runs. What would you build first with Java and Spring Boot? Let me know in the comments. Thanks for watching, and happy building.

---

## Episode 2 of 4 — Expose your endpoints to Copilot with the Model Context Protocol (MCP)

### Intro — Talking head (~20s)

> In this video, I'll show how a Spring Boot app becomes a set of tools GitHub Copilot can call directly in Visual Studio Code. I'll use Spring AI to expose the existing Java operations through the Model Context Protocol, or MCP, while keeping the web interface and Copilot connected to the same service. Let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

**Prerequisites:** Clone the finished sample from the GitHub URL in the video description and open it in VS Code, sign in to GitHub Copilot Chat, and allow MCP tool use when VS Code prompts for trust or confirmation.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `pom.xml` | Show the dependency **`spring-ai-starter-mcp-server-webmvc`** and the `spring-ai-bom` 2.0.0. | "I've cloned the finished Todo sample and opened it in VS Code. The GitHub URL for the sample is in the video description. The app already has the operations I want Copilot to use. To expose them through MCP, I'll start with Spring AI's WebMVC MCP server starter. The Spring AI Bill of Materials manages the dependency version, which is 2.0.0 here." |
| `mcp/TodoTools.java` | Walk through the `@McpTool` / `@McpToolParam` annotations on `addTodo`, `listTodos`, etc. Point out they just delegate to `TodoService`. | "With the server support in place, this class defines what Copilot can call. Each `@McpTool` supplies a name and description, while `@McpToolParam` describes the required input. Together, the five methods let Copilot list, get, add, complete, and delete Todos. Every method delegates to the same Todo service the web interface uses." |
| `application.properties` | Highlight `spring.ai.mcp.server.protocol=STREAMABLE`. | "Those annotations define the tools. Next, the application needs to expose them over the transport VS Code will use. Setting the protocol to STREAMABLE creates the modern Streamable HTTP endpoint at `/mcp`. Without this setting, the starter uses its older Server-Sent Events transport and `/mcp` is not available." |
| Terminal | In a dedicated terminal, run `.\mvnw.cmd spring-boot:run` and wait for **`Registered tools: 5`**. Leave this terminal running. | "Now that the tools and transport are configured, I'll start the application. During startup, Spring discovers the annotated methods, and `Registered tools: 5` confirms that the complete tool set is available." |
| `.vscode/mcp.json` | Show the `todo-mcp` entry for the running web endpoint. After the app is running, click its **Start** code-lens and approve the connection if prompted. | "The Java server is ready, but VS Code still needs its address. This `todo-mcp` entry points to the running `/mcp` endpoint. Starting the entry connects VS Code to the server and discovers its tools; it does not start the Java application." |
| Copilot Chat (Agent mode) | Enable the `todo-mcp` tools. Ask: *"Use the todo-mcp tools to add a todo called 'Email the stakeholders', then list all todos."* Refresh http://localhost:8080 and verify that exact title appears. | "With those tools discovered and enabled, I'll ask Copilot to add a Todo and then list the results. Copilot calls the MCP tools, which delegate to the Todo service. When I refresh the web page, the same title appears because both interfaces use the same service and in-memory repository." |
| Terminal / `.vscode/mcp.json` | After capturing the result, stop the Spring Boot app with `Ctrl+C`, then stop the `todo-mcp` connection. | "That matching item confirms that Copilot and the web page are working with the same application state. I'll stop the server, which clears its in-memory data, and close the MCP connection so the workspace returns to a clean state." |

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

**Prerequisites:** Clone the finished sample from the GitHub URL in the video description and open it in a current version of VS Code. Install the Spring Boot Extension Pack, sign in to GitHub Copilot Chat, and allow MCP server installation and tool use when prompted.

### Demo

| Where | Do | Say |
|-------|----|-----|
| VS Code — Extensions view (`Ctrl+Shift+X`) | Search **`@mcp playwright`**, select the Playwright MCP server, and choose **Install** to add it to the VS Code user profile. Review the publisher and configuration, confirm that you trust the server, and wait for it to start. Open the Chat tools picker and confirm the Playwright tools are available. | "I've cloned the finished Todo sample and opened it in VS Code. The GitHub URL for the sample is in the video description. To test this app through a real browser, Copilot first needs the Playwright tools. I'll search the MCP server gallery from the Extensions view and choose Install. That adds Playwright to my VS Code user profile without changing this workspace's MCP configuration. After I review and trust the server, VS Code starts it, discovers its tools, and makes them available to Copilot Chat." |
| Spring Boot Dashboard | Find **springboot-mcp-demo**, select its **Run** action, and wait for the app to show as running on http://localhost:8080. | "The Playwright tools are now installed and available; next they need a live site to exercise. I'll stay in VS Code and start the sample from the Spring Boot Dashboard. Once the Dashboard shows it running on port 8080, Copilot has a live app to test." |
| `templates/index.html` | Point out the `data-testid` hooks: `new-todo-input`, `add-todo`, `todo-item`, `delete-todo`. | "Before I hand over the browser, I'll show how the page supports reliable automation. These `data-testid` hooks give the input, add button, Todo rows, and delete buttons stable selectors that do not depend on the page's styling." |
| Copilot Chat (Agent mode, Playwright MCP) | Ask: *"Use the Playwright tools to open http://localhost:8080. Add a todo called 'Verify the browser flow', find that todo's row, complete it and verify it is checked, then delete it and verify it is gone."* | "With the browser server connected, the app running, and stable selectors in place, I'll give Copilot one complete user journey. It must add a specific Todo, find and complete that item, verify the checkbox, then delete the item and verify it is gone. The prompt defines the result; Copilot decides which Playwright actions to use." |
| Browser window (Playwright) | Watch the automated browser perform the add → complete → delete flow. | "Copilot now translates that goal into actions in the browser. I'll watch it fill and submit the form, find the new row, toggle the checkbox, and delete the item. The checks after completion and deletion confirm that the page changed, not just that the controls were clicked." |
| Copilot Chat | Return to Chat and review the completed Playwright tool calls and final response. Confirm that Playwright loaded **Java TODO Demo**, added **Verify the browser flow**, observed its checkbox as checked, deleted it, and found no matching text afterward. | "The browser showed each action as it happened. Back in Chat, Copilot confirms that it loaded the Todo app, added the named item, observed its checkbox as checked, deleted it, and found no matching text afterward. Those are assertions against the page state, not just a record of clicks." |
| Copilot Chat / Spring Boot Dashboard | Close the Playwright browser page, then use the app's **Stop** action in the Dashboard. Leave the Playwright MCP server installed in the VS Code user profile. | "The complete browser journey passed, so I'll close the Playwright page and stop the app from the Spring Boot Dashboard. Playwright remains installed in my VS Code user profile, ready for Copilot Chat in this or another workspace." |

**Illustrative browser state during a Playwright run; the live Copilot tool calls are shown during the demo:**

![Playwright run](../docs/images/07-playwright-run.png)

### Outro — Talking head (~20s)

> And there it is. I connected Playwright to GitHub Copilot through the Model Context Protocol and had Copilot test the Spring Boot app in a real browser. It added a Todo, completed it, deleted it, and verified each result. Combined with the unit and integration tests, that gives me confidence in both the code and the experience a user actually sees. What browser workflow would you ask Copilot to test in your own app? Let me know in the comments. Thanks for watching, and happy building.

---

## Episode 4 of 4 — Hand a feature to the Copilot cloud agent

### Intro — Talking head (~20s)

> In this video, I'll hand the GitHub Copilot coding agent a complete feature for a Spring Boot Todo app and review the pull request it creates in Visual Studio Code. The issue asks the agent to save todos in a database so they survive restarts and to add an optional due date. It also asks for updates to the tools exposed through the Model Context Protocol, or MCP, plus tests for the new behavior. Let's jump right in.

**Do:** End on “let's jump right in,” then cut to screen share.

**Prerequisites:** Clone the finished sample from the GitHub URL in the video description and open it in VS Code. Use a GitHub account with Copilot coding agent enabled, write access to the demo repository, and the GitHub Pull Requests extension signed in to VS Code.

**Recording plan:** Assign the issue before recording and let the asynchronous agent finish. During the video, use the prepared issue and draft pull request—do not create a duplicate or wait live. Before verifying the pull-request branch, start with an empty local H2 data directory; once the verification creates data, keep it in place for the restart check. Keep the pull request unmerged until every recording that depends on the in-memory baseline is complete.

### Demo

| Where | Do | Say |
|-------|----|-----|
| `docs/copilot-agent-issue.md` | Open it; show the ready-to-assign task: add **Spring Data JPA** persistence with an **H2 database** and a **`dueDate`** field with filtering. | "I've cloned the finished Todo sample and opened it in VS Code. The GitHub URL for the sample is in the video description. The starting app keeps everything in memory, so a restart erases its data. This issue replaces that store with a file-backed H2 database through Spring Data JPA. JPA is the standard interface for mapping Java objects to database records. The issue also defines optional due dates, filtering, and tests, giving the agent a concrete contract to implement." |
| GitHub — prepared issue | Open the issue that was assigned to **@copilot** before recording. | "With the scope and acceptance criteria written down, I can delegate the issue instead of sending an open-ended prompt. I assigned this prepared issue to Copilot before recording. The coding agent works asynchronously in the cloud, so it can implement the feature and open a pull request without an unpredictable live wait." |
| GitHub Pull Requests view (VS Code) | Open the draft pull request after the implementation commit has arrived; update it with the current baseline, then review the 13-file feature diff, including the JPA entity, repository, `dueDate`, MCP changes, and tests. | "That assignment produced this draft pull request. I'll first bring in the current baseline, then review the 13-file feature diff. I'm looking for the requested JPA entity and repository, the due date across the app and MCP tools, and tests for the new behavior. Draft status means the work is ready for review, not automatically approved." |
| Pull-request branch + Terminal | Check out the updated pull-request branch and start the app with `.\mvnw.cmd spring-boot:run`. | "The diff shows how the feature was built; now I need to see how it behaves. I'll check out the updated pull-request branch and start the application, which gives VS Code the new MCP server to call." |
| `.vscode/mcp.json` + Copilot Chat | Start `todo-mcp`, enable its tools, and confirm that all six are available: `add_todo`, `complete_todo`, `delete_todo`, `get_todo`, `list_todos`, and `set_due_date`. Ask: *"Use the todo-mcp tools to add a todo called 'Review the release', set its due date to 2000-01-01, then list only overdue todos and verify that item appears."* Confirm the returned item has that due date. | "With the updated app running, I'll connect VS Code to its MCP endpoint. The contract should now contain six tools, including `set_due_date`, while `list_todos` supports filtering. I'll use a date far in the past so the result is deterministic: if Copilot creates the Todo, sets that date, and finds it in the overdue list, all three behaviors work together." |
| Terminal + Copilot Chat | Stop and restart the app. Restart the `todo-mcp` connection if needed, then ask: *"Use the todo-mcp tools to list overdue todos."* Confirm **Review the release** and its due date are still present. | "That Chat result proves the due date and filter work in one running process. Persistence requires one more check, so I'll stop and restart the application, reconnect the tools, and ask for overdue Todos again. If the same item and due date return, the H2 database has preserved them across the restart." |
| Terminal / `.vscode/mcp.json` → Pull request review | Stop the application and the `todo-mcp` connection, then return to the pull request. Review the results and leave comments if needed. Keep the pull request draft and unmerged during this recording; only mark it ready and merge after the review is complete and the baseline has been preserved. | "The persisted item gives me both the code review and the live behavior to work from. I'll stop the local application and MCP connection, return to the pull request, and leave comments if anything needs attention. I'll keep it in draft until the review is complete, then make the final decision with the evidence in front of me." |

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

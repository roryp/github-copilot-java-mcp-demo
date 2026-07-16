// Automated screenshot capture for the demo recording script.
//
// Captures every BROWSER-based shot so you don't have to snip them by hand:
//   01-web-app.png            the running Todo app with items
//   02-actuator-health.png    the /actuator/health JSON
//   03-mcp-added-todo.png     the app after a real add_todo MCP call
//   07-playwright-run.png     Playwright mid-run (the full flow is then verified)
//   08-issue-assigned.png     (optional) the assigned GitHub issue   -> set GH_ISSUE_URL
//   09-agent-pr.png           (optional) the agent's pull request    -> set GH_PR_URL
//
// It uses your installed Microsoft Edge via Playwright's "msedge" channel —
// no multi-hundred-MB browser download.
//
// Prereqs:
//   1) npm install            (in this folder — pulls playwright-core only)
//   2) Spring Boot app running: from the repo root  .\mvnw.cmd spring-boot:run
//
// Usage (from scripts/screenshots):
//   node capture.mjs                              # app + playwright-run shots
//   $env:GH_ISSUE_URL="https://github.com/OWNER/REPO/issues/NN"
//   $env:GH_PR_URL="https://github.com/OWNER/REPO/pull/NN"
//   node capture.mjs                              # also captures 08 + 09
//
// Env vars (all optional):
//   BASE_URL      default http://localhost:8080
//   OUT_DIR       default ../../docs/images
//   HEADLESS      set to "1" to hide the browser window (default: headed)
//   GH_ISSUE_URL  capture 08-issue-assigned.png
//   GH_PR_URL     capture 09-agent-pr.png

import { chromium } from 'playwright-core';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import fs from 'node:fs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const BASE_URL = process.env.BASE_URL ?? 'http://localhost:8080';
const MCP_URL = process.env.MCP_URL ?? BASE_URL + '/mcp';
const OUT_DIR = process.env.OUT_DIR
  ? path.resolve(process.env.OUT_DIR)
  : path.resolve(__dirname, '..', '..', 'docs', 'images');
const HEADLESS = process.env.HEADLESS === '1';
const PROFILE_DIR = path.resolve(__dirname, '.edge-profile');

fs.mkdirSync(OUT_DIR, { recursive: true });

const shot = async (page, name) => {
  await page.screenshot({ path: path.join(OUT_DIR, name) });
  console.log('  saved docs/images/' + name);
};

async function ensureTodos(page, titles) {
  for (const title of titles) {
    const exists = await page
      .locator('[data-testid="todo-item"]', { hasText: title })
      .count();
    if (exists) continue;
    await page.fill('[data-testid="new-todo-input"]', title);
    await page.click('[data-testid="add-todo"]');
    await page.waitForLoadState('networkidle');
  }
}

async function removeTodoByTitle(page, title) {
  while (true) {
    const rows = page.locator('[data-testid="todo-item"]');
    let match = null;
    for (let index = 0; index < await rows.count(); index += 1) {
      const row = rows.nth(index);
      if ((await row.locator('span').textContent())?.trim() === title) {
        match = row;
        break;
      }
    }
    if (!match) return;
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle' }),
      match.locator('[data-testid="delete-todo"]').click(),
    ]);
  }
}

function parseMcpPayload(body) {
  const dataLines = body
    .split(/\r?\n/)
    .filter((line) => line.startsWith('data:'))
    .map((line) => line.slice('data:'.length).trim());
  return JSON.parse(dataLines.at(-1) ?? body);
}

async function callMcpTool(name, arguments_) {
  const baseHeaders = {
    accept: 'application/json, text/event-stream',
    'content-type': 'application/json',
  };
  const initialize = await fetch(MCP_URL, {
    method: 'POST',
    headers: baseHeaders,
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: 1,
      method: 'initialize',
      params: {
        protocolVersion: '2025-06-18',
        capabilities: {},
        clientInfo: { name: 'screenshot-capture', version: '1.0.0' },
      },
    }),
  });
  if (!initialize.ok) throw new Error(`MCP initialize failed: ${initialize.status}`);
  const sessionId = initialize.headers.get('mcp-session-id');
  if (!sessionId) throw new Error('MCP initialize returned no session id');
  const initializePayload = parseMcpPayload(await initialize.text());
  if (initializePayload.error) throw new Error(initializePayload.error.message);

  const sessionHeaders = { ...baseHeaders, 'mcp-session-id': sessionId };
  const initialized = await fetch(MCP_URL, {
    method: 'POST',
    headers: sessionHeaders,
    body: JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }),
  });
  if (!initialized.ok) throw new Error(`MCP initialized notification failed: ${initialized.status}`);

  const call = await fetch(MCP_URL, {
    method: 'POST',
    headers: sessionHeaders,
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: 2,
      method: 'tools/call',
      params: { name, arguments: arguments_ },
    }),
  });
  if (!call.ok) throw new Error(`MCP ${name} call failed: ${call.status}`);
  const payload = parseMcpPayload(await call.text());
  if (payload.error) throw new Error(payload.error.message);
  if (payload.result?.isError) throw new Error(payload.result.content?.[0]?.text ?? 'MCP tool error');
  return JSON.parse(payload.result.content[0].text);
}

async function addTodoThroughMcp(title) {
  const todo = await callMcpTool('add_todo', { title });
  if (todo.title !== title) throw new Error(`MCP returned unexpected todo title: ${todo.title}`);
  return todo;
}

async function clearTodosThroughMcp() {
  const todos = await callMcpTool('list_todos', {});
  for (const todo of todos) {
    const result = await callMcpTool('delete_todo', { id: todo.id });
    if (result !== `Deleted todo ${todo.id}`) {
      throw new Error(`MCP returned an unexpected delete result for todo ${todo.id}`);
    }
  }
}

function needsGitHubLogin(page) {
  return /\/(login|session)/.test(new URL(page.url()).pathname);
}

async function main() {
  const context = await chromium.launchPersistentContext(PROFILE_DIR, {
    channel: 'msedge',
    headless: HEADLESS,
    viewport: { width: 1200, height: 800 },
  });
  const page = context.pages()[0] ?? (await context.newPage());

  // ---- App shots -----------------------------------------------------------
  let appUp = true;
  const skipApp = process.env.SKIP_APP === '1';
  try {
    await page.goto(BASE_URL, { waitUntil: 'domcontentloaded', timeout: 5000 });
  } catch {
    appUp = false;
    console.warn(
      '! App not reachable at ' + BASE_URL +
      ' - start it (.\\mvnw.cmd spring-boot:run) then rerun. Skipping app shots.'
    );
  }

  if (appUp && !skipApp) {
    console.log('Capturing app shots...');
    await clearTodosThroughMcp();
    await page.reload({ waitUntil: 'networkidle' });
    await ensureTodos(page, ['Buy milk', 'Ship the release', 'Water the plants']);
    await shot(page, '01-web-app.png');

    const healthResponse = await fetch(BASE_URL + '/actuator/health');
    if (!healthResponse.ok) throw new Error(`Actuator health request failed: ${healthResponse.status}`);
    const health = await healthResponse.json();
    const publicHealth = {
      status: health.status,
      components: Object.fromEntries(
        Object.entries(health.components ?? {}).map(([name, component]) => [name, { status: component.status }]),
      ),
    };
    await page.setContent(
      '<!doctype html><html><head><meta charset="utf-8"><title>Actuator health</title>' +
      '<style>body{font-family:Consolas,monospace;margin:32px;white-space:pre-wrap}</style></head>' +
      `<body>${JSON.stringify(publicHealth, null, 2)}</body></html>`,
    );
    await shot(page, '02-actuator-health.png');

    await page.goto(BASE_URL, { waitUntil: 'domcontentloaded' });
    const mcpTitle = 'Email the stakeholders';
    await removeTodoByTitle(page, mcpTitle);
    await addTodoThroughMcp(mcpTitle);
    await page.reload({ waitUntil: 'networkidle' });
    const mcpTodo = page.locator('[data-testid="todo-item"]', { hasText: mcpTitle });
    if (await mcpTodo.count() !== 1) throw new Error('MCP-created todo did not appear exactly once in the UI');
    await shot(page, '03-mcp-added-todo.png');

    // 07 - Playwright mid-run: capture the filled form, then complete and verify
    // the add -> toggle -> delete journey so this is more than a staged image.
    const browserFlowTitle = 'Prep the demo recording';
    await removeTodoByTitle(page, browserFlowTitle);
    await page.fill('[data-testid="new-todo-input"]', browserFlowTitle);
    await page.hover('[data-testid="add-todo"]');
    await shot(page, '07-playwright-run.png');
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle' }),
      page.click('[data-testid="add-todo"]'),
    ]);
    let browserFlowRow = page.locator('[data-testid="todo-item"]', { hasText: browserFlowTitle });
    if (await browserFlowRow.count() !== 1) throw new Error('Playwright did not add the browser-flow todo');
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle' }),
      browserFlowRow.getByRole('checkbox').check(),
    ]);
    browserFlowRow = page.locator('[data-testid="todo-item"]', { hasText: browserFlowTitle });
    if (!(await browserFlowRow.getByRole('checkbox').isChecked())) {
      throw new Error('Playwright did not complete the browser-flow todo');
    }
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle' }),
      browserFlowRow.locator('[data-testid="delete-todo"]').click(),
    ]);
    if (await page.locator('[data-testid="todo-item"]', { hasText: browserFlowTitle }).count()) {
      throw new Error('Playwright did not delete the browser-flow todo');
    }
  }

  // ---- GitHub shots (optional) --------------------------------------------
  const ghTargets = [
    ['GH_ISSUE_URL', '08-issue-assigned.png', 'issue'],
    ['GH_PR_URL', '09-agent-pr.png', 'pull request'],
  ];
  for (const [envVar, name, label] of ghTargets) {
    const url = process.env[envVar];
    if (!url) continue;
    console.log('Capturing GitHub ' + label + '...');
    await page.goto(url, { waitUntil: 'domcontentloaded' });
    if (needsGitHubLogin(page)) {
      console.warn('  Not signed in - a window is open. Sign in to GitHub (up to 2 min)...');
      await page
        .waitForURL((u) => !/\/(login|session)/.test(new URL(u).pathname), { timeout: 120000 })
        .catch(() => {});
      await page.goto(url, { waitUntil: 'domcontentloaded' });
    }
    await page.waitForTimeout(1500);
    await shot(page, name);
  }

  await context.close();
  console.log('Done. Output -> ' + OUT_DIR);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});

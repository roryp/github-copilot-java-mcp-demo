<#
    mcp-smoke-test.ps1

    Exercises the running Todo MCP server over the Streamable-HTTP transport at
    http://localhost:8080/mcp using raw JSON-RPC, the same protocol VS Code /
    GitHub Copilot use. Steps:
      1. initialize           -> opens a session (Mcp-Session-Id header)
      2. notifications/initialized
      3. tools/list           -> lists the exposed @McpTool methods
      4. tools/call add_todo  -> creates a todo through MCP

    Usage:  pwsh ./scripts/mcp-smoke-test.ps1   (or run in Windows PowerShell)
#>

param(
    [string]$BaseUrl = "http://localhost:8080/mcp"
)

$ErrorActionPreference = "Stop"
# Windows PowerShell 5.1: avoid the legacy IE-based HTML parser (and its prompt).
$PSDefaultParameterValues['Invoke-WebRequest:UseBasicParsing'] = $true
$accept = "application/json, text/event-stream"

function Read-McpBody($response) {
    # Streamable-HTTP responses may be SSE ("data: {json}") or plain JSON.
    $body = $response.Content
    $m = [regex]::Match($body, "data:\s*(\{.*\})")
    if ($m.Success) { return ($m.Groups[1].Value | ConvertFrom-Json) }
    return ($body | ConvertFrom-Json)
}

# 1. initialize ---------------------------------------------------------------
$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"mcp-smoke-test","version":"1.0.0"}}}'
$initResp = Invoke-WebRequest -Method Post $BaseUrl -Headers @{ Accept = $accept } -ContentType "application/json" -Body $initBody
$sessionId = ($initResp.Headers["Mcp-Session-Id"] | Select-Object -First 1)
$init = Read-McpBody $initResp
Write-Host ("1. initialize  -> server: {0} v{1}  (session {2})" -f $init.result.serverInfo.name, $init.result.serverInfo.version, $sessionId)

$sessionHeaders = @{ Accept = $accept; "Mcp-Session-Id" = $sessionId }

# 2. initialized notification -------------------------------------------------
Invoke-WebRequest -Method Post $BaseUrl -Headers $sessionHeaders -ContentType "application/json" `
    -Body '{"jsonrpc":"2.0","method":"notifications/initialized"}' | Out-Null
Write-Host "2. notifications/initialized -> sent"

# 3. tools/list ---------------------------------------------------------------
$listResp = Invoke-WebRequest -Method Post $BaseUrl -Headers $sessionHeaders -ContentType "application/json" `
    -Body '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
$list = Read-McpBody $listResp
$toolNames = ($list.result.tools | ForEach-Object { $_.name }) -join ", "
Write-Host ("3. tools/list  -> {0} tools: {1}" -f $list.result.tools.Count, $toolNames)

# 4. tools/call add_todo ------------------------------------------------------
$callBody = '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"add_todo","arguments":{"title":"Created through the MCP add_todo tool"}}}'
$callResp = Invoke-WebRequest -Method Post $BaseUrl -Headers $sessionHeaders -ContentType "application/json" -Body $callBody
$call = Read-McpBody $callResp
$text = $call.result.content[0].text
Write-Host ("4. tools/call add_todo -> {0}" -f $text)

Write-Host "`nMCP smoke test PASSED."

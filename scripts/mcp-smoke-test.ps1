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
    [string]$BaseUrl = "http://localhost:8080/mcp",
    [string[]]$ExpectedTools = @("add_todo", "complete_todo", "delete_todo", "get_todo", "list_todos")
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

function Assert-Condition([bool]$Condition, [string]$Message) {
    if (-not $Condition) {
        throw "MCP smoke test failed: $Message"
    }
}

# 1. initialize ---------------------------------------------------------------
$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"mcp-smoke-test","version":"1.0.0"}}}'
$initResp = Invoke-WebRequest -Method Post $BaseUrl -Headers @{ Accept = $accept } -ContentType "application/json" -Body $initBody
$sessionId = ($initResp.Headers["Mcp-Session-Id"] | Select-Object -First 1)
$init = Read-McpBody $initResp
Assert-Condition ($null -ne $sessionId -and "$sessionId".Length -gt 0) "initialize did not return an Mcp-Session-Id header"
Assert-Condition ($null -eq $init.error) "initialize returned JSON-RPC error: $($init.error.message)"
Assert-Condition ($init.result.serverInfo.name -eq "todo-mcp-server") "unexpected server name '$($init.result.serverInfo.name)'"
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
Assert-Condition ($null -eq $list.error) "tools/list returned JSON-RPC error: $($list.error.message)"
$actualTools = @($list.result.tools | ForEach-Object { $_.name } | Sort-Object)
$sortedExpectedTools = @(
    $ExpectedTools |
        ForEach-Object { $_ -split "," } |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ } |
        Sort-Object
)
$toolDifference = @(Compare-Object -ReferenceObject $sortedExpectedTools -DifferenceObject $actualTools)
Assert-Condition ($toolDifference.Count -eq 0) "tools/list did not return the expected tools (expected: $($sortedExpectedTools -join ', '); actual: $($actualTools -join ', '))"
$toolNames = $actualTools -join ", "
Write-Host ("3. tools/list  -> {0} tools: {1}" -f $actualTools.Count, $toolNames)

# 4. tools/call add_todo ------------------------------------------------------
$callBody = '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"add_todo","arguments":{"title":"Created through the MCP add_todo tool"}}}'
$callResp = Invoke-WebRequest -Method Post $BaseUrl -Headers $sessionHeaders -ContentType "application/json" -Body $callBody
$call = Read-McpBody $callResp
Assert-Condition ($null -eq $call.error) "tools/call returned JSON-RPC error: $($call.error.message)"
Assert-Condition ($call.result.isError -ne $true) "add_todo returned a tool error"
Assert-Condition (@($call.result.content).Count -gt 0) "add_todo returned no content"
$text = $call.result.content[0].text
$todo = $text | ConvertFrom-Json
Assert-Condition ($null -ne $todo.id) "add_todo result has no id"
Assert-Condition ($todo.title -eq "Created through the MCP add_todo tool") "add_todo returned the wrong title '$($todo.title)'"
Assert-Condition ($todo.completed -eq $false) "new todo was unexpectedly completed"
Write-Host ("4. tools/call add_todo -> {0}" -f $text)

Write-Host "`nMCP smoke test PASSED."

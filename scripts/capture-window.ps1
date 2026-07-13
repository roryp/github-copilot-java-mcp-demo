<#
    capture-window.ps1

    Screenshots the VS Code UI moments that Playwright CANNOT drive because they
    are VS Code's own chrome (no screenshot API exists for them):
        04-debug-breakpoint.png  paused breakpoint + Variables panel
        05-memory-view.png       Spring Boot Dashboard Memory view gauges
        06-copilot-mcp-chat.png  Copilot Chat panel with the todo-mcp tool call

    (The Spring Initializr picker, 00-initializr.png, is captured by its own
    keystroke-driven helper: scripts/capture-initializr.ps1.)

    HOW IT WORKS: it finds the actual VS Code window by its process (Code.exe) and
    captures it with the Win32 PrintWindow API using the PW_RENDERFULLCONTENT flag
    (2). That flag is the key - it makes PrintWindow capture GPU / DirectComposition
    surfaces, i.e. Electron/Chromium apps like VS Code (a plain screen grab or
    PrintWindow flag 0 returns black for those). This targets the real window, so it
    works even if VS Code isn't the foreground window - no Snipping Tool, no guessing.

    You still arrange the panel yourself (hit the breakpoint, open the Memory view,
    run the Copilot tool call) - the -Delay countdown gives you time to do that - but
    the capture itself is fully scripted.

    Examples (run from the repo root):
        # list the VS Code windows it can see (pick a title to target)
        pwsh ./scripts/capture-window.ps1 -List

        # capture the main VS Code window after a 5s countdown
        pwsh ./scripts/capture-window.ps1 -Out docs/images/04-debug-breakpoint.png -Delay 5

        # target a specific window by title substring, and bring it to front first
        pwsh ./scripts/capture-window.ps1 -Out docs/images/06-copilot-mcp-chat.png -TitleMatch "script.md" -Foreground
#>
param(
    [string]$Out,
    [string]$TitleMatch,
    [string]$Process = 'Code',
    [int]$Delay = 3,
    [switch]$List,
    [switch]$Foreground
)

if (-not $List -and -not $Out) { throw "Provide -Out <path> (or -List to see candidate windows)." }

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
if (-not ('WinShot' -as [type])) {
    Add-Type @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
public class WinShot {
    public delegate bool EnumProc(IntPtr hWnd, IntPtr lParam);
    [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc cb, IntPtr p);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] public static extern int GetWindowTextLength(IntPtr h);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    public struct RECT { public int Left, Top, Right, Bottom; }
    static List<IntPtr> _list;
    static EnumProc _cb;
    static bool Add(IntPtr h, IntPtr l) { _list.Add(h); return true; }
    public static IntPtr[] Windows() {
        _list = new List<IntPtr>();
        _cb = new EnumProc(Add);
        EnumWindows(_cb, IntPtr.Zero);
        return _list.ToArray();
    }
    public static string Text(IntPtr h) {
        int n = GetWindowTextLength(h);
        if (n <= 0) return "";
        var sb = new StringBuilder(n + 1);
        GetWindowText(h, sb, sb.Capacity);
        return sb.ToString();
    }
    public static uint Pid(IntPtr h) { uint pid; GetWindowThreadProcessId(h, out pid); return pid; }
}
"@
}
[void][WinShot]::SetProcessDPIAware()

# ---- find candidate windows belonging to the target process ----------------
$targetPids = @((Get-Process -Name $Process -ErrorAction SilentlyContinue).Id)
if (-not $targetPids) { throw "No running '$Process' process found. Is VS Code open?" }

$cands = foreach ($h in [WinShot]::Windows()) {
    if (-not [WinShot]::IsWindowVisible($h)) { continue }
    if ($targetPids -notcontains [int][WinShot]::Pid($h)) { continue }
    $title = [WinShot]::Text($h)
    if (-not $title) { continue }
    $iconic = [WinShot]::IsIconic($h)
    $r = New-Object WinShot+RECT
    [void][WinShot]::GetWindowRect($h, [ref]$r)
    $w = $r.Right - $r.Left; $ht = $r.Bottom - $r.Top
    # Skip small popups/tooltips, but KEEP minimized main windows (they report a tiny size and get restored before capture).
    if (-not $iconic -and ($w -lt 300 -or $ht -lt 200)) { continue }
    [pscustomobject]@{
        Handle = $h; Title = $title; W = $w; H = $ht; Iconic = $iconic; Area = $w * $ht
        IsMain = [int]($title -like '*Visual Studio Code*')
    }
}

if ($TitleMatch) { $cands = $cands | Where-Object { $_.Title -like "*$TitleMatch*" } }
# Prefer real VS Code main windows (title ends in 'Visual Studio Code'), then largest area.
$cands = @($cands | Sort-Object -Property @{Expression = 'IsMain'; Descending = $true}, @{Expression = 'Area'; Descending = $true})

if (-not $cands) { throw "No matching '$Process' window found$(if($TitleMatch){" for title '*$TitleMatch*'"})." }

if ($List) {
    $cands | Format-Table @{L='Size';E={"{0}x{1}" -f $_.W,$_.H}}, @{L='Min';E={$_.Iconic}}, Title -AutoSize
    return
}

$target = $cands[0]
Write-Host ("Target: {0}  ({1}x{2})" -f $target.Title, $target.W, $target.H)

# Resolve output path relative to the current directory and ensure its folder exists.
if ([System.IO.Path]::IsPathRooted($Out)) { $OutPath = $Out } else { $OutPath = Join-Path (Get-Location).Path $Out }
$OutPath = [System.IO.Path]::GetFullPath($OutPath)
$dir = [System.IO.Path]::GetDirectoryName($OutPath)
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

# A minimized window cannot be captured - restore it first. Also restore/raise on -Foreground.
if ($target.Iconic -or $Foreground) {
    [void][WinShot]::ShowWindow($target.Handle, 9)      # SW_RESTORE
    [void][WinShot]::SetForegroundWindow($target.Handle)
    Start-Sleep -Milliseconds 500
}

if ($Delay -gt 0) {
    Write-Host "Arrange the VS Code panel now..."
    for ($i = $Delay; $i -gt 0; $i--) { Write-Host ("  capturing in {0}s" -f $i); Start-Sleep -Seconds 1 }
}

function Test-Black($bmp) {
    $stepX = [Math]::Max(1, [int]($bmp.Width / 8))
    $stepY = [Math]::Max(1, [int]($bmp.Height / 8))
    for ($yy = 0; $yy -lt $bmp.Height; $yy += $stepY) {
        for ($xx = 0; $xx -lt $bmp.Width; $xx += $stepX) {
            $c = $bmp.GetPixel($xx, $yy)
            if ($c.R -gt 8 -or $c.G -gt 8 -or $c.B -gt 8) { return $false }
        }
    }
    return $true
}

# Re-read the rect right before capture (window may have moved during the delay).
$r = New-Object WinShot+RECT
[void][WinShot]::GetWindowRect($target.Handle, [ref]$r)
$w = $r.Right - $r.Left; $h = $r.Bottom - $r.Top

$bmp = New-Object System.Drawing.Bitmap($w, $h)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$hdc = $g.GetHdc()
# PW_RENDERFULLCONTENT = 2 -> captures GPU/Electron content (VS Code) even in background.
$ok = [WinShot]::PrintWindow($target.Handle, $hdc, 2)
$g.ReleaseHdc($hdc)
$g.Dispose()

if (-not $ok -or (Test-Black $bmp)) {
    Write-Host "PrintWindow came back empty - falling back to a foreground screen grab..."
    $bmp.Dispose()
    [void][WinShot]::ShowWindow($target.Handle, 9)
    [void][WinShot]::SetForegroundWindow($target.Handle)
    Start-Sleep -Milliseconds 500
    [void][WinShot]::GetWindowRect($target.Handle, [ref]$r)
    $w = $r.Right - $r.Left; $h = $r.Bottom - $r.Top
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($r.Left, $r.Top, 0, 0, (New-Object System.Drawing.Size($w, $h)))
    $g.Dispose()
}

$bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host ("Saved {0}  ({1} x {2})" -f $OutPath, $w, $h)

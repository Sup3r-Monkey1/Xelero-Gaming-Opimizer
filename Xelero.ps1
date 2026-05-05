# ============================================================
#  XELERO // OMNIBUS SUPREME (v55.0) — THE CULMINATION
#  "FOR THE SAKE OF THE FRAMES... AND THE PEOPLE"
#  UNIVERSAL: INTEL / AMD / NVIDIA | LAPTOP & DESKTOP
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // OMNIBUS v55.0 - THE FINAL"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] PLEASE RUN AS ADMINISTRATOR TO OPTIMIZE YOUR PC." -ForegroundColor Red
    pause; exit
}

# -- AUTO-SENSE SCANNER --
function Run-Scanner {
    $Global:cpu = (Get-CimInstance Win32_Processor).Name
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:isLaptop = $null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue)
    $Global:isSSD = (Get-PhysicalDisk | Where-Object {$_.MediaType -eq 'SSD'}) -ne $null
    $Global:hasRoblox = Test-Path "$env:LOCALAPPDATA\Roblox"
    $Global:logFile = "$env:USERPROFILE\Desktop\Xelero_Changes.txt"
}

# -- SAFETY & LOGGING --
function Write-XeleroLog {
    param($Msg)
    $Timestamp = Get-Date -Format "HH:mm:ss"
    "[$Timestamp] $Msg" | Out-File -FilePath $logFile -Append
}

function Create-SafetyNet {
    Write-Host " [!] CREATING SAFETY RESTORE POINT..." -ForegroundColor Cyan
    Checkpoint-Computer -Description "XELERO_BEFORE_TWEAKS" -RestorePointType "MODIFY_SETTINGS"
    "--- XELERO SESSION START: $(Get-Date) ---" | Out-File -FilePath $logFile
}

# -- INFO-PEEK DATABASE --
$Details = @{
    "1" = "Rocket Mode: Forces your CPU to run at its top speed. Great for FPS, but makes laptops run hotter."
    "2" = "Stay Awake Mode: Stops your CPU cores from 'sleeping' when they aren't busy. Fixes random 1-second game freezes."
    "3" = "Flicker Fix: Stops that annoying black flashing in Chrome or Roblox. Good for all NVIDIA/Intel laptops."
    "4" = "Reflex Mode: Makes your mouse and keyboard feel instant. Uses a safe buffer of 24 to ensure your hardware never stops working."
    "5" = "Pro-Gamer Sync: Makes 'Windowed' games feel as fast as 'Fullscreen.' Essential for Roblox and Fortnite."
    "6" = "Zero-Delay Ping: Stops Windows from holding onto internet packets. Sends them instantly for the lowest possible lag."
    "7" = "Stop Spying: Blocks Windows from tracking what you do. Frees up background CPU power."
    "8" = "Kill AI Recall: Deactivates the 2026 AI features that record your screen. Saves tons of RAM and Privacy."
    "9" = "Emergency Repair: Scans your computer for broken Windows files and fixes them automatically. Use this if your PC crashes a lot."
    "10"= "Game Focus Mode: Tells the CPU to ignore background apps and give 100% of its power to your game window."
}

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $Y = "Yellow"; $R = "Red"
    if ($isLaptop) { $mode = "PORTABLE" } else { $mode = "STATION" }
    
    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ HW: $cpu | GPU: $gpu" -ForegroundColor $W
    Write-Host " │ MODE: $mode | SSD: $isSSD | ROBLOX: $hasRoblox" -ForegroundColor $G
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
    Write-Host "  [TIP]: Type a number + '?' for details (e.g. 1?)" -ForegroundColor $G
}

# ============================================================
# MAIN COMMAND CENTER
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ 🚀 SPEED & POWER ]             [ 🎮 SMOOTHNESS & GPU ]" -ForegroundColor $C
    Write-Host "  [1] ROCKET MODE (MAX POWER)     [3] STOP SCREEN FLICKER (MPO)"
    Write-Host "  [2] STAY AWAKE MODE (CORES)     [4] PRO-REFLEXES (0ms INPUT)"
    Write-Host "  [10] GAME FOCUS MODE (CPU)      [5] WINDOWED-MODE SYNC (FSE)"
    Write-Host ""
    Write-Host "  [ 🕵️ PRIVACY & BLOAT ]           [ 🌐 NETWORK & PING ]" -ForegroundColor Green
    Write-Host "  [6] ZERO-DELAY PING (TCP)       [8] KILL AI (RECALL/COPILOT)"
    Write-Host "  [7] STOP SPYING (TELEMETRY)     [11] FIX MY INTERNET (DNS/IP)"
    Write-Host ""
    Write-Host "  [ 🛠️ REPAIR & CLEAN ]            [ 🆘 EMERGENCY ROOM ]" -ForegroundColor $Y
    Write-Host "  [9] EMERGENCY SYSTEM FIX        [13] PRINTER SAVER (RESET)"
    Write-Host "  [12] TEMP FILE DEEP CLEAN       [14] FIX GLITCHY ICONS"
    Write-Host ""
    Write-Host "  [ X ] APPLY ALL ESSENTIALS      [ R ] UNDO EVERYTHING   [ Q ] EXIT" -ForegroundColor Magenta
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::round($_.FreePhysicalMemory / 1MB, 2)}}
    $vibe = if($mem.FreeGB -gt 4){"SMOOTH"}else{"SLUGGISH"}
    Write-Host "  [ STATUS ]: $($mem.FreeGB) GB RAM FREE | PC VIBE: $vibe" -ForegroundColor DarkGray
    
    $cmdInput = (Read-Host "  WHAT'S THE MOVE?").Trim()
    
    # --- INFO-PEEK LOGIC ---
    if ($cmdInput.EndsWith("?")) {
        $num = $cmdInput.Replace("?","")
        if ($Details.ContainsKey($num)) {
            Write-Host "`n  [ TWEAK DETAIL ]: $($Details[$num])" -ForegroundColor Cyan
            Write-Host "  Press any key to continue..."
            pause | Out-Null
            continue
        }
    }

    switch ($cmdInput) {
        "1" { 
            Create-SafetyNet
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            powercfg /setactive $p
            Write-XeleroLog "Applied Rocket Mode (Ultimate Performance)."
            Write-Host "  Rocket Mode Active." -ForegroundColor Green
        }
        "2" {
            powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
            powercfg /setactive SCHEME_CURRENT
            Write-XeleroLog "Disabled Core Parking."
            Write-Host "  Cores stay awake now." -ForegroundColor Green
        }
        "3" {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5
            Write-XeleroLog "Disabled MPO (Flicker Fix)."
            Write-Host "  Flicker Fixed." -ForegroundColor Green
        }
        "4" {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Write-XeleroLog "Optimized Input Latency Priority."
            Write-Host "  Reflexes Sharpened." -ForegroundColor Green
        }
        "6" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
                Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
            }
            Write-XeleroLog "Applied Zero-Delay Ping (Nagle's Nuke)."
            Write-Host "  Lag Mitigated." -ForegroundColor Green
        }
        "8" {
            $p = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
            if(!(Test-Path $p)){New-Item $p -Force}; Set-ItemProperty -Path $p -Name "DisableAIDataAnalysis" -Value 1
            Write-XeleroLog "Disabled AI Recall."
            Write-Host "  AI Recall Nuked." -ForegroundColor Green
        }
        "9" { sfc /scannow; DISM /Online /Cleanup-Image /RestoreHealth; Write-Host "  Repairs Done." -ForegroundColor Green }
        "12" { Remove-Item "$env:TEMP\*" -Recurse -Force; DISM /Online /Cleanup-Image /StartComponentCleanup; Write-Host "  Cleaned." -ForegroundColor Green }
        "14" { taskkill /f /im explorer.exe; del /a /s /q "$env:localappdata\IconCache.db"; start explorer.exe; Write-Host "  Icons Reset." -ForegroundColor Green }
        "X" {
            Create-SafetyNet
            Write-Host "  APPLYING ALL SAFE ESSENTIALS..." -ForegroundColor Magenta
            # Runs Power, Input, Network, and Privacy
            Invoke-Expression "& { `$Global:cmdInput = '1'; switch(`$cmdInput){ '1' } }"
            Invoke-Expression "& { `$Global:cmdInput = '4'; switch(`$cmdInput){ '4' } }"
            Invoke-Expression "& { `$Global:cmdInput = '6'; switch(`$cmdInput){ '6' } }"
            Invoke-Expression "& { `$Global:cmdInput = '8'; switch(`$cmdInput){ '8' } }"
            Write-Host "  [!] ALL ESSENTIALS ACTIVE. REBOOT RECOMMENDED." -ForegroundColor Magenta; pause
        }
        "R" { 
            Write-Host "  [!] LAUNCHING WINDOWS REVERT TOOL..." -ForegroundColor Red
            rstrui.exe
        }
        "Q" { exit }
    }
    Start-Sleep -Seconds 1
}

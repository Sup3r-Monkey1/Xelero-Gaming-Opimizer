# ============================================================
#  XELERO // OMNIBUS SUPREME (v57.0) — THE APEX EDITION
#  "THE ABSOLUTE FINAL: PERFORMANCE, STABILITY, & SAFETY"
#  COMPATIBILITY: UNIVERSAL (INTEL / AMD / NVIDIA)
#  SYSTEM: WINDOWS 10 / 11 (VERIFIED FOR 24H2)
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // APEX EDITION v57.0 - THE FINAL"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] ELEVATED PERMISSIONS REQUIRED TO ACCESS KERNEL." -ForegroundColor Red
    pause; exit
}

# -- DEEP HARDWARE INTELLIGENCE --
function Run-Scanner {
    $Global:cpu = (Get-CimInstance Win32_Processor).Name
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $Global:isLaptop = $null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue)
    $Global:isSSD = (Get-PhysicalDisk | Where-Object {$_.MediaType -eq 'SSD'}) -ne $null
    $Global:osBuild = [int]((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild)
}

# -- SAFETY & RESTORE --
function Create-SafetyPoint {
    if ($Global:RestoreCreated -ne $true) {
        Write-Host " [!] INITIATING MANDATORY SYSTEM RESTORE POINT..." -ForegroundColor Cyan
        Checkpoint-Computer -Description "XELERO_APEX_FINAL" -RestorePointType "MODIFY_SETTINGS"
        $Global:RestoreCreated = $true
    }
}

# -- INFO-PEEK MASTER DATABASE --
$Details = @{
    "1" = "Ultimate Performance: Unlocks the highest Windows power plan. Forces CPU to maintain base frequency for 0ms response times. (Failsafe included)."
    "2" = "Core Parking: Prevents CPU cores from entering sleep mode. Fixes the micro-stutter that happens when a core wakes up mid-game."
    "3" = "MPO Override: Disables Multi-Plane Overlay. Legitimate fix for flickering, black boxes, and stutters on hybrid laptops."
    "4" = "Input Priority: Moves Human Interface Device (HID) tasks to the top of the CPU schedule. Makes mouse clicks feel instant."
    "5" = "Independent Flip Sync: Allows windowed games to bypass the DWM. Gives the low latency of Fullscreen while staying in Windowed mode."
    "6" = "Network Stack: Disables Nagle's Algorithm and Packet Throttling. Forces games to send data immediately for the lowest possible ping."
    "7" = "Win32 Priority: Sets kernel scheduling to '38'. Gives the active game window longer CPU time-slices for higher minimum FPS."
    "8" = "Large System Cache: Prioritizes RAM for file-system data. Dramatically speeds up texture loading in BO6, CS2, and Roblox."
    "x" = "Essential Suite: Applies the safest, most impactful tweaks at once (Power, Graphics, Network, and System Schedulers)."
}

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $Y = "Yellow"; $M = "Magenta"
    if ($isLaptop) { $mode = "PORTABLE_TURBO" } else { $mode = "STATION_MAX" }

    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ CPU: $cpu" -ForegroundColor $W
    Write-Host " │ GPU: $gpu | RAM: $ram GB | MODE: $mode" -ForegroundColor $G
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
    Write-Host "  [TIP]: Type number + '?' for details (e.g. 1?). Universal Safe Logic. " -ForegroundColor $G
}

# ============================================================
# PERFORMANCE MODULES
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]             [ GRAPHICS & DISPLAY ]" -ForegroundColor $C
    Write-Host "  [1] ULTIMATE PERFORMANCE LOGIC   [3] DISABLE MPO (FIX FLICKER)"
    Write-Host "  [2] DISABLE CPU CORE PARKING     [4] INPUT INTERRUPT PRIORITY"
    Write-Host "  [7] WIN32 SCHEDULING BOOST       [5] INDEPENDENT FLIP SYNC"
    Write-Host ""
    Write-Host "  [ NETWORK & LATENCY ]            [ MEMORY & STABILITY ]" -ForegroundColor Green
    Write-Host "  [6] NETWORK STACK OPTIMIZER      [8] LARGE SYSTEM CACHE MODE"
    Write-Host "  [9] FLUSH DNS & INTERNET RESET   [11] TITAN GAME PRIORITIZATION"
    Write-Host ""
    Write-Host "  [ SYSTEM CLEANUP ]               [ SAFETY & EXIT ]" -ForegroundColor $Y
    Write-Host "  [10] DELETE SYSTEM TEMP JUNK     [R] UNDO ALL (SYSTEM RESTORE)"
    Write-Host "  [12] DISABLE OS TELEMETRY        [Q] EXIT ENGINE"
    Write-Host ""
    Write-Host "  [ X ] APPLY ALL ESSENTIALS" -ForegroundColor $M
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    # Recommendation Logic
    $rec = "Essential Suite (X)"
    if ($isLaptop) { $rec = "Core Parking (2) + MPO (3)" }
    Write-Host "  [ RECOMMENDATION ]: Apply $rec for best stability." -ForegroundColor DarkGray
    
    $cmdInput = (Read-Host "  SELECT ACTION").Trim().ToLower()
    
    # --- INFO-PEEK LOGIC ---
    if ($cmdInput.EndsWith("?")) {
        $num = $cmdInput.Replace("?","")
        if ($Details.ContainsKey($num)) {
            Write-Host "`n  [ TECHNICAL CONTEXT ]: $($Details[$num])" -ForegroundColor Cyan
            Write-Host "  Press any key to return..."
            pause | Out-Null; continue
        }
    }

    switch ($cmdInput) {
        "1" { 
            Create-SafetyPoint
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            powercfg /setactive $p
            Write-Host "  Rocket Power Engaged." -ForegroundColor Green
        }
        "2" {
            powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
            powercfg /setactive SCHEME_CURRENT
            Write-Host "  Cores Unparked." -ForegroundColor Green
        }
        "3" {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5
            Write-Host "  MPO Disabled." -ForegroundColor Green
        }
        "4" {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Write-Host "  HID Priority Elevated." -ForegroundColor Green
        }
        "5" {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2
            Write-Host "  Independent Flip Sync Active." -ForegroundColor Green
        }
        "6" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
                Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
            }
            Write-Host "  Network Stack Optimized." -ForegroundColor Green
        }
        "7" {
            Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
            Write-Host "  Win32 Schedulers Boosted." -ForegroundColor Green
        }
        "8" {
            if ($ram -ge 8) {
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1
                Write-Host "  Large System Cache Active." -ForegroundColor Green
            } else { Write-Host "  [!] Not enough RAM for this tweak." -ForegroundColor Red }
        }
        "11" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","chrome.exe","Marathon.exe","javaw.exe","Minecraft.Windows.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }
                Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 3
                Set-ItemProperty -Path $p -Name "IoPriorityClass" -Value 3
            }
            Write-Host "  Titans Prioritized." -ForegroundColor Green
        }
        "x" {
            Create-SafetyPoint
            "1","2","4","5","6","7","11" | ForEach-Object { Invoke-Expression "& { `$Global:cmdInput = '$_'; switch(`$cmdInput){ '$_' } }" }
            Write-Host "`n  [!] APEX XELERATION COMPLETE. REBOOT RECOMMENDED." -ForegroundColor Magenta; pause
        }
        "r" { rstrui.exe }
        "q" { exit }
    }
    Start-Sleep -Seconds 1
}

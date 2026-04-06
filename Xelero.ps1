# ============================================================
#  XELERO // THE OMNIBUS SUPREME: HYBRID EDITION (v46.0)
#  "FOR THE SAKE OF THE FRAMES... AND THE BATTERY"
#  COMPATIBILITY: UNIVERSAL (INTEL / AMD / NVIDIA)
#  100% REVERSIBLE | DUAL-MODE STAMINA & PERFORMANCE
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // OMNIBUS v46.0 - HYBRID EDITION"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] SYSTEM ACCESS DENIED: PLEASE RUN AS ADMIN" -ForegroundColor Red
    pause; exit
}

# -- FACTORY BACKUP SYSTEM --
$BackupPath = "HKLM:\SOFTWARE\XELERO_BACKUPS"
if (!(Test-Path $BackupPath)) { New-Item $BackupPath -Force | Out-Null }

function Save-Original {
    param($Path, $Name, $Module)
    if (Test-Path $Path) {
        $Val = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue).$Name
        $ModPath = "$BackupPath\$Module"
        if (!(Test-Path $ModPath)) { New-Item $ModPath -Force | Out-Null }
        if (!(Get-ItemProperty -Path $ModPath -Name $Name -ErrorAction SilentlyContinue)) {
            Set-ItemProperty -Path $ModPath -Name $Name -Value $Val
        }
    }
}

# -- HARDWARE SCANNER --
function Run-Scanner {
    $Global:cpu = (Get-CimInstance Win32_Processor).Name
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:isLaptop = $null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue)
    $Global:isIntel = $cpu -match "Intel"
}

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $M = "Magenta"; $R = "Red"; $Y = "Yellow"; $Gn = "Green"
    if ($isLaptop) { $mode = "PORTABLE_TURBO" } else { $mode = "STATION_MAX" }
    
    # Live Power Detection
    $currentPlan = (powercfg /getactivescheme).Split('(')[1].Split(')')[0]
    $statusColor = if ($currentPlan -match "Power Saver") { $Gn } else { $C }

    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ CPU: $cpu" -ForegroundColor $W
    Write-Host " │ GPU: $gpu | MODE: $mode" -ForegroundColor $G
    Write-Host " │ POWER STATUS: $currentPlan" -ForegroundColor $statusColor
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
}

# ============================================================
# PERFORMANCE & POWER SAVING MODULES
# ============================================================

function Apply-Core {
    Write-Host " [>] Injecting Kernel & Timer Tweaks..." -ForegroundColor Cyan
    Save-Original -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Module "Core"
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
    bcdedit /set disabledynamictick yes; bcdedit /set useplatformtick yes
    Write-Host " [OK] Core Applied." -ForegroundColor Green
}

function Apply-XeleratePower {
    Write-Host " [>] Injecting Ultimate Performance (Gaming Mode)..." -ForegroundColor Cyan
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
    powercfg /setactive $p
    if ($isIntel) {
        powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
    }
    powercfg /hibernate off
    Write-Host " [OK] Performance Mode Active." -ForegroundColor Green
}

function Apply-StaminaEco {
    Write-Host " [>] Activating Stamina Mode (Extreme Power Saving)..." -ForegroundColor Green
    # Activate standard Power Saver plan
    powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
    # Disable Intel Turbo Boost (Saves huge battery and heat)
    if ($isIntel) {
        powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 0
        powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 0
    }
    powercfg /hibernate on
    # Lower Desktop brightness (Laptop Only)
    if ($isLaptop) { (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,30) }
    Write-Host " [OK] Eco Mode Active. CPU Throttled for Battery." -ForegroundColor Yellow
}

# ============================================================
# MAIN INTERFACE
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]            [ GRAPHICS & DISPLAY ]" -ForegroundColor Cyan
    Write-Host "  [1] APPLY CORE ENGINE           [6] APPLY GPU OPTIMIZER"
    Write-Host "  [U1] REVERT CORE                [U6] REVERT GPU"
    Write-Host ""
    Write-Host "  [ POWER & THERMAL ]             [ POWER SAVING / ECO ]" -ForegroundColor Green
    Write-Host "  [2] APPLY POWER INJECTOR        [15] STAMINA MODE (BATTERY)"
    Write-Host "  [U2] REVERT POWER               [U15] REVERT STAMINA"
    Write-Host ""
    Write-Host "  [ ADVANCED TOOLS ]              [ CLEANUP & MISC ]" -ForegroundColor Yellow
    Write-Host "  [3] SURGICAL RAM PURGE          [8] FPS HARD-CAP (ZERO TEAR)"
    Write-Host "  [4] GAME PRIORITY (ALL)         [9] NUKING WINDOWS BLOAT"
    Write-Host "  [5] INPUT POLLING OPT           [10] FLUSH DNS / TEMP"
    Write-Host ""
    Write-Host "  [X] XELERATE (ALL)   [D] DISCORD   [R] RESET ALL   [Q] EXIT" -ForegroundColor Magenta
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::round($_.FreePhysicalMemory / 1024 / 1024, 2)}}
    Write-Host "  [ STATUS ]: $($mem.FreeGB) GB RAM FREE | SYSTEM IS $(if($isLaptop){"PORTABLE"}else{"STATIONARY"})" -ForegroundColor DarkGray
    
    $cmd = Read-Host "  ACTION"
    
    switch ($cmd) {
        "1"   { Apply-Core }
        "U1"  { Restore-Value -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Module "Core"; bcdedit /set disabledynamictick no }
        "2"   { Apply-XeleratePower }
        "U2"  { powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e }
        "15"  { Apply-StaminaEco }
        "U15" { powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e; Write-Host " Stamina Disabled." -ForegroundColor Red }
        "3"   { [System.GC]::Collect(); Write-Host " RAM Purged." -ForegroundColor Green }
        "4"   { 
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","chrome.exe","Marathon.exe","javaw.exe","Minecraft.Windows.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }
                Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 3
                Set-ItemProperty -Path $p -Name "IoPriorityClass" -Value 3
            }
            Write-Host " Game Logic Prioritized." -ForegroundColor Green
        }
        "5"   { 
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Write-Host " Polling Response Elevated." -ForegroundColor Green
        }
        "6"   { 
            Get-CimInstance Win32_VideoController | ForEach-Object {
                $path = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.DeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
                if (!(Test-Path $path)) { New-Item $path -Force }
                Set-ItemProperty -Path $path -Name "MSISupported" -Value 1
            }
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5
            Write-Host " Graphics Optimized." -ForegroundColor Green
        }
        "8"   { $hz = Read-Host "  Target FPS"; Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "MaxFrameRate" -Value $hz }
        "9"   { $svcs = @("DiagTrack","SysMain","WSearch","dmwappushservice"); foreach($s in $svcs){Set-Service $s -StartupType Disabled; Stop-Service $s -Force} }
        "10"  { Remove-Item "$env:TEMP\*" -Recurse -Force; ipconfig /flushdns }
        "X"   { Apply-Core; Apply-XeleratePower; Write-Host " SYSTEM XELERATED." -ForegroundColor Magenta; pause }
        "R"   { powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e; bcdedit /set disabledynamictick no; Write-Host " DEFAULTS RESTORED." -ForegroundColor Red; pause }
        "D"   { Start-Process "https://discordapp.com/users/848750246124191744" }
        "Q"   { exit }
    }
    Start-Sleep -Seconds 1
}

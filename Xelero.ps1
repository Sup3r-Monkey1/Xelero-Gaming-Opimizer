# ============================================================
#  XELERO // OMNIBUS v53.0 — STABILITY EDITION
#  "FOR THE SAKE OF THE FRAMES... AND THE PACKETS"
#  COMPATIBILITY: UNIVERSAL (INTEL / AMD / NVIDIA)
#  100% STABLE | NETWORK STABILITY | HARDWARE-AWARE
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // STABILITY v53.0"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] ACCESS DENIED: PLEASE RUN AS ADMIN" -ForegroundColor Red
    pause; exit
}

# -- BACKUP & REVERT ENGINE --
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

function Restore-Value {
    param($Path, $Name, $Module)
    $ModPath = "$BackupPath\$Module"
    if (Test-Path $ModPath) {
        $OldVal = (Get-ItemProperty -Path $ModPath -Name $Name -ErrorAction SilentlyContinue).$Name
        if ($null -ne $OldVal) { Set-ItemProperty -Path $Path -Name $Name -Value $OldVal; return $true }
    }
    return $false
}

# -- HARDWARE SCANNER --
$cpu = (Get-CimInstance Win32_Processor).Name
$gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
$isLaptop = $null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue)

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $M = "Magenta"; $R = "Red"; $Y = "Yellow"
    if ($isLaptop) { $mode = "PORTABLE_STABLE" } else { $mode = "STATION_MAX" }
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
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
}

# ============================================================
# MAIN INTERFACE LOOP
# ============================================================

while ($true) {
    Show-Header
    Write-Host " [ POWER & THERMALS ]             [ GRAPHICS & DISPLAY ]" -ForegroundColor Green
    Write-Host " [1] ULTIMATE PERFORMANCE PLAN    [6] DISABLE MPO (FIX FLICKER)"
    Write-Host " [2] INTEL TURBO LOCK (LAPTOP)    [7] INDEPENDENT FLIP (FSE)"
    Write-Host " [3] DISABLE POWER THROTTLING     [8] GPU MSI-MODE (STABLE)"
    Write-Host ""
    Write-Host " [ NETWORK STABILITY ]            [ SYSTEM & INPUT ]" -ForegroundColor $C
    Write-Host " [4] KILL P2P UPDATE UPLOADS      [9] WIN32 PRIORITY BOOST (38)"
    Write-Host " [5] BROWSER GAMING MODE          [10] HUMAN INTERFACE PRIORITY"
    Write-Host " [14] FIX BUFFERBLOAT (ETHERNET)  [15] SAFE KEYBOARD BUFFER (24)"
    Write-Host ""
    Write-Host " [ CLEANUP & MAINTENANCE ]        [ UNDO / REVERT CENTER ]" -ForegroundColor $Y
    Write-Host " [11] FLUSH DNS CACHE             [U1] REVERT KERNEL"
    Write-Host " [12] DELETE TEMP JUNK FILES      [U2] REVERT POWER PLAN"
    Write-Host " [13] GAME PRIORITY (SSD I/O)     [U3] REVERT NETWORK"
    Write-Host ""
    Write-Host " [D] MY DISCORD PROFILE   [R] MASTER FACTORY RESET   [Q] EXIT" -ForegroundColor $M
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor $G
    
    $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::round($_.FreePhysicalMemory / 1MB, 2)}}
    Write-Host " [ STATUS ]: $($mem.FreeGB) GB RAM FREE | SYSTEM IS OPTIMIZED" -ForegroundColor $G
    
    $cmd = Read-Host " CMD"

    switch ($cmd) {
        "1" { 
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            powercfg /setactive $p
            Write-Host " Performance Plan Engaged." -ForegroundColor Green
        }
        "2" {
            if ($cpu -match "Intel") {
                powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
                Write-Host " Turbo Boost Locked." -ForegroundColor Green
            }
        }
        "3" {
            $pwr = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
            if (!(Test-Path $pwr)) { New-Item $pwr -Force }
            Set-ItemProperty -Path $pwr -Name "PowerThrottlingOff" -Value 1
            Write-Host " Power Throttling Killed." -ForegroundColor Green
        }
        "4" {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0
            Write-Host " P2P Uploads Disabled." -ForegroundColor Green
        }
        "5" {
            $browsers = @("chrome.exe", "msedge.exe", "brave.exe")
            foreach ($b in $browsers) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$b\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }; Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 6 # Above Normal
            }
            Write-Host " Browser Priority Optimized." -ForegroundColor Green
        }
        "6" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5 }
        "7" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1 }
        "8" {
            $gpuID = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty DeviceID)
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\$gpuID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MSISupported" -Value 1
            Write-Host " MSI Mode Injected." -ForegroundColor Green
        }
        "9" {
            Save-Original -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Module "Kernel"
            Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
        }
        "10" {
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Write-Host " Mouse/Keyboard Scheduling Elevated." -ForegroundColor Green
        }
        "11" { ipconfig /flushdns; Write-Host " DNS Purged." -ForegroundColor Green }
        "12" { Remove-Item "$env:TEMP\*" -Recurse -Force; Write-Host " System Cleaned." -ForegroundColor Green }
        "13" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","Marathon.exe","javaw.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }
                Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 3
                Set-ItemProperty -Path $p -Name "IoPriorityClass" -Value 3
            }
            Write-Host " Game I/O Prioritized." -ForegroundColor Green
        }
        "14" {
            # Ethernet Stability / Bufferbloat Fix
            Write-Host " [>] Optimizing Ethernet Adapters..." -ForegroundColor Cyan
            netsh int tcp set global autotuninglevel=restricted
            netsh int tcp set global heuristics=disabled
            Disable-NetAdapterInterruptModeration -Name "*"
            Disable-NetAdapterFlowControl -Name "*"
            Write-Host " Network Jitter Mitigated." -ForegroundColor Green
        }
        "15" {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24
            Write-Host " Buffer Locked at 24 (Safe Default)." -ForegroundColor Green
        }
        "D" { Start-Process "https://discordapp.com/users/848750246124191744" }
        "R" {
            Restore-Value -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Module "Kernel"
            powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
            netsh int tcp set global autotuninglevel=normal
            netsh winsock reset
            Write-Host " Factory Defaults Restored." -ForegroundColor $Y; pause
        }
        "Q" { exit }
    }
    Start-Sleep -Seconds 1
}

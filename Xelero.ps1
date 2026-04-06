# ============================================================
#  XELERO // THE OMNIBUS SUPREME: GHOST EDITION (v47.0)
#  "FOR THE SAKE OF THE FRAMES... AND THE BATTERY"
#  COMPATIBILITY: UNIVERSAL (INTEL / AMD / NVIDIA)
#  DUAL-CORE ENGINE: [X] XELERATE  VS  [E] GHOST MODE
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // OMNIBUS v47.0 - GHOST EDITION"
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
    
    # Live Power Detection
    $currentPlan = (powercfg /getactivescheme).Split('(')[1].Split(')')[0]
    $statusColor = if ($currentPlan -match "Power Saver") { $Gn } else { $C }
    $modeText = if ($currentPlan -match "Power Saver") { "GHOST_ECO" } else { "XELERATE_TURBO" }

    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ CPU: $cpu" -ForegroundColor $W
    Write-Host " │ GPU: $gpu | TARGET: $modeText" -ForegroundColor $G
    Write-Host " │ POWER STATUS: $currentPlan" -ForegroundColor $statusColor
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
}

# ============================================================
# DUAL-CORE ENGINE MODULES
# ============================================================

function Apply-GhostMode {
    Write-Host " [>] Activating GHOST MODE (Extreme Battery Stamina)..." -ForegroundColor Green
    
    # 1. Universal Power Saver GUID
    powercfg -setactive a1841308-3541-4fab-bc81-f71556f20b4a
    
    # 2. Hardware Choke (CPU 50% Max, No Turbo, PCIe ASPM Max)
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 50
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 0
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 3
    powercfg /setdcvalueindex SCHEME_CURRENT 44e04870-5b5d-4f24-9c1a-ee4930331f3e 3619013c-0e7f-4422-a9b0-96f7c8f9435b 0
    
    # 3. UI Silence (Save GPU cycles)
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
    
    # 4. Kill Background UWP Apps
    if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications")) { New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Force }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
    
    # 5. Service Hibernation
    $stoppers = @("wuauserv", "BITS", "bthserv", "Spooler", "WSearch")
    foreach($s in $stoppers){ Stop-Service $s -Force }
    
    Write-Host " [OK] GHOST MODE ACTIVE. Hardware is now Silent." -ForegroundColor Yellow
}

function Apply-Xelerate {
    Write-Host " [>] Activating XELERATE (Performance Boost)..." -ForegroundColor Cyan
    
    # 1. Ultimate Performance Plan Injector
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
    powercfg /setactive $p
    
    # 2. Maximize Hardware (100% CPU, Aggressive Turbo, No Parking)
    powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    if ($isIntel) {
        powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
    }
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
    
    # 3. Kernel & Graphics Optimization
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5
    
    Write-Host " [OK] XELERATE ACTIVE. Hardware is Primed." -ForegroundColor Magenta
}

# ============================================================
# MAIN INTERFACE
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]            [ GRAPHICS & DISPLAY ]" -ForegroundColor Cyan
    Write-Host "  [1] FPS HARD-CAP (ZERO TEAR)    [6] GPU MSI-MODE (HIGH SPEED)"
    Write-Host "  [2] RAW INPUT OVERCLOCK         [7] DISABLE MPO (FIX FLICKER)"
    Write-Host "  [3] TANK SYSTEM SOUNDS          [8] DISABLE FSE / GAME DVR"
    Write-Host ""
    Write-Host "  [ SYSTEM CLEANUP ]              [ NETWORKING & LATENCY ]" -ForegroundColor Green
    Write-Host "  [4] NUKING WINDOWS BLOAT        [9] ZERO-DELAY NETWORK"
    Write-Host "  [5] FLUSH DNS / TEMP FILES      [10] DISABLE NAGLE'S ALGORITHM"
    Write-Host ""
    Write-Host "  [ ADVANCED TOOLS ]              [ UNDO / REVERT CENTER ]" -ForegroundColor Yellow
    Write-Host "  [11] RAM PURGE (FIX STUTTER)    [U1] REVERT NETWORK"
    Write-Host "  [12] SET GAME PRIORITY (ALL)    [U2] REVERT KERNEL"
    Write-Host ""
    Write-Host "  [X] XELERATE (MAX PERF)  [E] GHOST MODE (BATTERY)  [D] DISCORD  [Q] EXIT" -ForegroundColor Magenta
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::round($_.FreePhysicalMemory / 1024 / 1024, 2)}}
    Write-Host "  [ STATUS ]: $($mem.FreeGB) GB RAM FREE | XELERO ACTIVE" -ForegroundColor DarkGray
    
    $cmd = Read-Host "  CMD"
    
    switch ($cmd) {
        "1" { $hz = Read-Host "  Target FPS"; Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "MaxFrameRate" -Value $hz }
        "2" { Apply-Xelerate }
        "3" { reg add "HKCU\AppEvents\Schemes" /ve /t REG_SZ /d ".None" /f }
        "4" { $svcs = @("DiagTrack","SysMain","WSearch","dmwappushservice"); foreach($s in $svcs){Set-Service $s -StartupType Disabled; Stop-Service $s -Force} }
        "5" { Remove-Item "$env:TEMP\*" -Recurse -Force; ipconfig /flushdns }
        "6" { 
            $gpuID = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty DeviceID)
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\$gpuID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MSISupported" -Value 1 
        }
        "7" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5 }
        "8" { Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 }
        "9" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Save-Original -Path $_.PSPath -Name "TcpAckFrequency" -Module "Network"
                Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
                Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
            }
        }
        "11" { 
            # Surgical RAM Purge
            $code = 'using System; using System.Diagnostics; using System.Runtime.InteropServices; public class RAM { [DllImport("kernel32.dll")] public static extern bool SetProcessWorkingSetSize(IntPtr proc, int min, int max); public static void Purge() { foreach (Process p in Process.GetProcesses()) { try { SetProcessWorkingSetSize(p.Handle, -1, -1); } catch { } } } }'
            Add-Type -TypeDefinition $code; [RAM]::Purge(); [System.GC]::Collect(); Write-Host " RAM Purged." -ForegroundColor Green
        }
        "12" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","chrome.exe","Marathon.exe","javaw.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }; Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 3
            }
        }
        "E" { Apply-GhostMode; pause }
        "X" { Apply-Xelerate; pause }
        "U1" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                $v = (Get-ItemProperty -Path "$BackupPath\Network" -Name "TcpAckFrequency" -EA SilentlyContinue).TcpAckFrequency
                if($v){Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value $v}
            }
        }
        "D" { Start-Process "https://discordapp.com/users/848750246124191744" }
        "Q" { exit }
    }
    Start-Sleep -Seconds 1
}

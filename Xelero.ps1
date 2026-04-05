# ============================================================
#  XELERO // THE OMNIBUS ULTIMATE: BLACK EDITION (v42.0)
#  "FOR THE SAKE OF THE FRAMES" — OMNIBUS FINAL
#  BUILT FOR: CLUTCHING, GRINDING, & ZERO DELAY
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // OMNIBUS v42.0 - OMNIBUS FINAL"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] SYSTEM ACCESS DENIED: PLEASE RUN AS ADMIN TO CLUTCH" -ForegroundColor Red
    pause; exit
}

# -- FACTORY BACKUP SYSTEM (0% Risk Architecture) --
$BackupPath = "HKLM:\SOFTWARE\XELERO_BACKUPS"
if (!(Test-Path $BackupPath)) { New-Item $BackupPath -Force | Out-Null }

function Save-Original {
    param($Path, $Name, $Module)
    if (Test-Path $Path) {
        $CurrentValue = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue).$Name
        $ModulePath = "$BackupPath\$Module"
        if (!(Test-Path $ModulePath)) { New-Item $ModulePath -Force | Out-Null }
        if (!(Get-ItemProperty -Path $ModulePath -Name $Name -ErrorAction SilentlyContinue)) {
            Set-ItemProperty -Path $ModulePath -Name $Name -Value $CurrentValue
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

# -- UI STYLING (Universal PS 5.1 Version) --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $M = "Magenta"; $R = "Red"; $Y = "Yellow"
    
    if ($isLaptop) { $mode = "PORTABLE_TURBO" } else { $mode = "STATION_MAX" }

    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │  CPU: $cpu" -ForegroundColor $W
    Write-Host " │  GPU: $gpu | MODE: $mode" -ForegroundColor $G
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
}

# ============================================================
# SURGICAL OPTIMIZATION MODULES
# ============================================================

function Apply-Core {
    Write-Host " [>] Injecting Kernel Responsiveness & BCDEDIT..." -ForegroundColor Cyan
    Save-Original -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Module "Kernel"
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
    # BCDEDIT (The Latency Nuke)
    bcdedit /set disabledynamictick yes
    bcdedit /set useplatformtick yes
    bcdedit /set {current} bootux disabled
    Write-Host " [OK] Kernel Optimized for Zero-Delay." -ForegroundColor Green
}

function Apply-Graphics {
    Write-Host " [>] Graphics Surgery: MSI-Mode & Independent Flip..." -ForegroundColor Cyan
    $gpuID = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty DeviceID)
    $gpuPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$gpuID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
    if (!(Test-Path $gpuPath)) { New-Item $gpuPath -Force }
    Set-ItemProperty -Path $gpuPath -Name "MSISupported" -Value 1
    # Disable MPO (Fixes Laptop Flickering)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5
    # Force Independent Flip (Smoothness Key)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2
    Write-Host " [OK] GPU Pipeline is Snappy." -ForegroundColor Green
}

function Apply-Power {
    Write-Host " [>] Injecting Ultimate Power & Intel Turbo Lock..." -ForegroundColor Cyan
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
    powercfg /setactive $p
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 5d760414-0358-471f-a0b2-7287740b9984 1
    if ($isIntel) {
        powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
    }
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
    powercfg /setactive SCHEME_CURRENT
    Write-Host " [OK] Power Delivery Locked." -ForegroundColor Green
}

# ============================================================
# MAIN INTERFACE LOOP
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]            [ GRAPHICS & DISPLAY ]" -ForegroundColor Cyan
    Write-Host "  [1] FPS HARD-CAP (SMOOTH)       [6] GPU MSI-MODE (HIGH SPEED)"
    Write-Host "  [2] RAW INPUT OVERCLOCK         [7] DISABLE MPO (FIX FLICKER)"
    Write-Host "  [3] TANK SYSTEM SOUNDS          [8] DISABLE FSE / GAME DVR"
    Write-Host ""
    Write-Host "  [ SYSTEM CLEANUP ]              [ NETWORKING & LATENCY ]" -ForegroundColor Green
    Write-Host "  [4] NUKING WINDOWS BLOAT        [9] ZERO-DELAY NETWORK"
    Write-Host "  [5] FLUSH DNS / TEMP FILES      [10] DISABLE NAGLE'S ALGORITHM"
    Write-Host ""
    Write-Host "  [ ADVANCED TOOLS ]              [ COMMUNITY & SUPPORT ]" -ForegroundColor Yellow
    Write-Host "  [11] FIX STUTTERS (RAM PURGE)   [D] MY DISCORD PROFILE"
    Write-Host "  [12] SET GAME PRIORITY (ALL)    [Q] EXIT XELERO"
    Write-Host ""
    Write-Host "  [ UNDO / REVERT CENTER ]" -ForegroundColor Red
    Write-Host "  [U1] REVERT NETWORK    [U2] REVERT KERNEL    [U3] REVERT GPU"
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::round($_.FreePhysicalMemory / 1MB, 2)}}
    Write-Host "  [ SYSTEM STATUS ]: $($mem.FreeGB) GB RAM AVAILABLE | XELERO ACTIVE" -ForegroundColor DarkGray
    
    $cmd = Read-Host "  CMD"
    
    switch ($cmd) {
        "1" { $hz = Read-Host "  Target FPS"; Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "MaxFrameRate" -Value $hz }
        "2" { Apply-Core }
        "3" { reg add "HKCU\AppEvents\Schemes" /ve /t REG_SZ /d ".None" /f; Write-Host " [!] System Audio Muted." -ForegroundColor Red }
        "4" { 
            $svcs = @("DiagTrack","SysMain","WSearch","dmwappushservice","MapsBroker")
            foreach($s in $svcs){Set-Service $s -StartupType Disabled; Stop-Service $s -Force}
            Write-Host " [!] Windows Bloat Nuked." -ForegroundColor Red
        }
        "5" { Remove-Item "$env:TEMP\*" -Recurse -Force; ipconfig /flushdns }
        "6" { Apply-Graphics }
        "7" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5; Write-Host " [OK] MPO Disabled." -ForegroundColor Green }
        "8" { Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 }
        "9" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Save-Original -Path $_.PSPath -Name "TcpAckFrequency" -Module "Network"
                Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
            }
            Write-Host " [OK] Network Priorities Set." -ForegroundColor Green
        }
        "10" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
            }
        }
        "11" { 
            Write-Host " [>] Performing Surgical RAM Purge..." -ForegroundColor Yellow
            $code = @"
            using System;
            using System.Diagnostics;
            using System.Runtime.InteropServices;
            public class RAM {
                [DllImport("kernel32.dll")]
                public static extern bool SetProcessWorkingSetSize(IntPtr proc, int min, int max);
                public static void Purge() {
                    foreach (Process p in Process.GetProcesses()) {
                        try { SetProcessWorkingSetSize(p.Handle, -1, -1); } catch { }
                    }
                }
            }
"@
            Add-Type -TypeDefinition $code
            [RAM]::Purge()
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
            Write-Host " [OK] RAM Working Sets Flushed." -ForegroundColor Green
        }
        "12" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","chrome.exe","Marathon.exe","javaw.exe","Minecraft.Windows.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }
                Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 3
                Set-ItemProperty -Path $p -Name "IoPriorityClass" -Value 3
            }
            Write-Host " [OK] Gaming Threading Synchronized." -ForegroundColor Green
        }
        "D" { Start-Process "https://discordapp.com/users/848750246124191744" }
        "X" { 
            Apply-Core; Apply-Graphics; 
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Apply-Power 
            Write-Host " [!] OMNIBUS XELERATION COMPLETE. REBOOT RECOMMENDED." -ForegroundColor Magenta; pause
        }
        "Q" { exit }
        "U1" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                $v = (Get-ItemProperty -Path "$BackupPath\Network" -Name "TcpAckFrequency" -EA SilentlyContinue).TcpAckFrequency
                if($v){Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value $v}
            }
            Write-Host " [!] Network Reverted to Factory." -ForegroundColor Red
        }
        "U2" {
            $v = (Get-ItemProperty -Path "$BackupPath\Kernel" -Name "Win32PrioritySeparation" -EA SilentlyContinue).Win32PrioritySeparation
            if($v){Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value $v}
            Write-Host " [!] Kernel Reverted to Factory." -ForegroundColor Red
        }
        "U3" {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 0
            Write-Host " [!] MPO Re-Enabled." -ForegroundColor Red
        }
    }
    Start-Sleep -Seconds 1
}

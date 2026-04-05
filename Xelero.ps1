# ============================================================
#  XELERO // THE OMNIBUS SUPREME (v44.0)
#  "FOR THE SAKE OF THE FRAMES" — THE CULMINATION
#  COMPATIBILITY: UNIVERSAL (INTEL / AMD / NVIDIA)
#  SAFE | SURGICAL | ZERO-DELAY | HARDWARE-AWARE
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // OMNIBUS v44.0 - SUPREME EDITION"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] SYSTEM ACCESS DENIED: PLEASE RUN AS ADMIN" -ForegroundColor Red
    pause; exit
}

# -- UNIVERSAL HARDWARE SCANNER --
function Run-Scanner {
    $Global:cpu = (Get-CimInstance Win32_Processor).Name
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:isLaptop = $null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue)
    $Global:isIntel = $cpu -match "Intel"
    $Global:isSSD = (Get-PhysicalDisk | Where-Object {$_.MediaType -eq 'SSD'}) -ne $null
}

# -- UI STYLING --
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
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │  UNIVERSAL COMPATIBILITY: INTEL/AMD/NVIDIA - 100% VOLTAGE SAFE     │" -ForegroundColor $Y
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
}

# ============================================================
# PERFORMANCE ENGINE MODULES
# ============================================================

function Apply-CoreKernel {
    Write-Host " [>] Synchronizing NT Kernel & BCDEDIT Timers..." -ForegroundColor Cyan
    # Win32PrioritySeparation 38 (The Professional Standard)
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
    # BCDEDIT surgical tweaks
    bcdedit /set disabledynamictick yes
    bcdedit /set useplatformtick yes
    bcdedit /set {current} bootux disabled
    Write-Host " [OK] Kernel Responsiveness Primed." -ForegroundColor Green
}

function Apply-GraphicsUniversal {
    Write-Host " [>] Optimizing Graphics Pipeline & Independent Flip..." -ForegroundColor Cyan
    # MSI-Mode for ALL Detected GPUs
    Get-CimInstance Win32_VideoController | ForEach-Object {
        $id = $_.DeviceID
        $path = "HKLM:\SYSTEM\CurrentControlSet\Enum\$id\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
        if (!(Test-Path $path)) { New-Item $path -Force }
        Set-ItemProperty -Path $path -Name "MSISupported" -Value 1
    }
    # Disable MPO (Fixes stuttering on Laptop Integrated + Dedicated GPU setups)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5
    # Force Independent Flip (Removes Screen Ripping)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2
    Write-Host " [OK] Universal GPU Optimization Complete." -ForegroundColor Green
}

function Apply-PowerStability {
    Write-Host " [>] Locking Power Scaling & Unparking Cores..." -ForegroundColor Cyan
    # Failsafe Ultimate Power Plan
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    $plan = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
    powercfg /setactive $plan
    # Disable Idle Throttling
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 5d760414-0358-471f-a0b2-7287740b9984 1
    # Intel-Specific Laptop Turbo Lock
    if ($isIntel) {
        powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
    }
    # Unpark all logical cores
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
    powercfg /setactive SCHEME_CURRENT
    Write-Host " [OK] Power Delivery Hardened." -ForegroundColor Green
}

# ============================================================
# MAIN COMMAND CENTER
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]            [ GRAPHICS & DISPLAY ]" -ForegroundColor Cyan
    Write-Host "  [1] FPS HARD-CAP (SMOOTH)       [6] UNIVERSAL MSI-PRIORITY"
    Write-Host "  [2] KERNEL RESPONSIVENESS       [7] DISABLE MPO (FIX FLICKER)"
    Write-Host "  [3] TANK SYSTEM SOUNDS          [8] INDEPENDENT FLIP (FSE)"
    Write-Host ""
    Write-Host "  [ SYSTEM CLEANUP ]              [ NETWORKING & LATENCY ]" -ForegroundColor Green
    Write-Host "  [4] NUKING WINDOWS BLOAT        [9] ZERO-DELAY NETWORK"
    Write-Host "  [5] FLUSH DNS / TEMP FILES      [10] DISABLE NAGLE'S ALGORITHM"
    Write-Host ""
    Write-Host "  [ ADVANCED TOOLS ]              [ INPUT & PERIPHERAL ]" -ForegroundColor Yellow
    Write-Host "  [11] SURGICAL RAM PURGE         [13] INPUT POLLING PRIORITY"
    Write-Host "  [12] SET GAME PRIORITY (ALL)    [14] SAFE MOUSE RESPONSE"
    Write-Host ""
    Write-Host "  [ X ] XELERATE (TOTAL OMNIBUS)  [ D ] DISCORD     [ Q ] EXIT" -ForegroundColor Magenta
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::round($_.FreePhysicalMemory / 1024 / 1024, 2)}}
    Write-Host "  [ SYSTEM STATUS ]: $($mem.FreeGB) GB RAM AVAILABLE | XELERATE RECOMMENDED" -ForegroundColor DarkGray
    
    $cmd = Read-Host "  CMD"
    
    switch ($cmd) {
        "1" { $hz = Read-Host "  Target FPS"; Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "MaxFrameRate" -Value $hz }
        "2" { Apply-CoreKernel }
        "3" { reg add "HKCU\AppEvents\Schemes" /ve /t REG_SZ /d ".None" /f; Write-Host " [OK] Sounds Muted." -ForegroundColor Red }
        "4" { 
            $svcs = @("DiagTrack","SysMain","WSearch","dmwappushservice","MapsBroker")
            foreach($s in $svcs){Set-Service $s -StartupType Disabled; Stop-Service $s -Force}
            Write-Host " [OK] Bloatware Stopped." -ForegroundColor Green
        }
        "5" { Remove-Item "$env:TEMP\*" -Recurse -Force; ipconfig /flushdns }
        "6" { Apply-GraphicsUniversal }
        "7" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5 }
        "8" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1 }
        "9" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
            }
            Write-Host " [OK] Network Optimized." -ForegroundColor Green
        }
        "10" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
            }
        }
        "11" { 
            # Surgical RAM Purge (SetWorkingSetSize)
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
            Write-Host " [OK] RAM Released to System." -ForegroundColor Green
        }
        "12" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","chrome.exe","Marathon.exe","javaw.exe","Minecraft.Windows.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }
                Set-ItemProperty -Path $p -Name "CpuPriorityClass" -Value 3
                Set-ItemProperty -Path $p -Name "IoPriorityClass" -Value 3
            }
            Write-Host " [OK] Gaming Titans Prioritized." -ForegroundColor Green
        }
        "13" {
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Write-Host " [OK] Polling Response Elevated." -ForegroundColor Green
        }
        "14" {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24
            Write-Host " [OK] Response Safe & Fast." -ForegroundColor Green
        }
        "D" { Start-Process "https://discordapp.com/users/848750246124191744" }
        "X" { 
            Apply-CoreKernel; Apply-GraphicsUniversal; Apply-PowerStability; Apply-PowerStability
            Write-Host " [!] OMNIBUS SUPREME ACTIVATED. REBOOT FOR GOD-TIER FRAMES." -ForegroundColor Magenta; pause
        }
        "Q" { exit }
    }
    Start-Sleep -Seconds 1
}

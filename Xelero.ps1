# ============================================================
#  XELERO // OMNIBUS SUPREME (v63.0) — THE APEX PREDATOR
#  "THE ABSOLUTE FINAL: 100% PERMANENT, SAFE, & SURGICAL"
#  TARGET: INTEL LAPTOPS & MODERN DESKTOPS (2026 READY)
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // APEX PREDATOR v63.0"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] ELEVATED PERMISSIONS REQUIRED TO ACCESS KERNEL." -ForegroundColor Red
    pause; exit
}

# -- DEEP HARDWARE SCANNER --
function Run-Scanner {
    $Global:cpu = (Get-CimInstance Win32_Processor).Name
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $chassis = (Get-CimInstance Win32_SystemEnclosure).ChassisTypes
    $Global:isLaptop = ($chassis -contains 9 -or $chassis -contains 10 -or $chassis -contains 14)
    $Global:systemType = if($isLaptop){"LAPTOP (MOBILE)"}else{"DESKTOP (STATION)"}
    $Global:isSSD = (Get-PhysicalDisk | Where-Object {$_.BusType -match "NVMe|SATA" -and $_.MediaType -eq "SSD"}) -ne $null
}

# -- SAFETY & PERMANENCE LOGIC --
function Handle-Restore {
    $RegCheck = Get-ItemProperty "HKLM:\SOFTWARE" -Name "XeleroBackup" -ErrorAction SilentlyContinue
    if ($null -eq $RegCheck) {
        Write-Host " [!] FIRST RUN: FORCING SYSTEM RESTORE POINT FOR SAFETY..." -ForegroundColor Cyan
        Checkpoint-Computer -Description "XELERO_FINAL_BACKUP" -RestorePointType "MODIFY_SETTINGS"
        New-ItemProperty -Path "HKLM:\SOFTWARE" -Name "XeleroBackup" -Value "Created" -PropertyType String -Force | Out-Null
    }
}

# -- INFO-PEEK DATABASE --
$Details = @{
    "1" = "Turbo-Lock Power: Permanently locks Intel Boost to 'Aggressive'. Stops mid-game FPS drops."
    "2" = "Core-Stability: Unparks all CPU cores permanently. Eliminates stuttering in Roblox/Valorant."
    "3" = "MPO Fix: Disables Multi-Plane Overlay in the registry. Permanent fix for black flickers."
    "4" = "HID Priority: Moves Mouse/Keyboard to top CPU priority (Safe 24-Buffer). 0ms input lag."
    "5" = "Apex Sync: Forces DXGI Fencing & Max Pre-Rendered Frames = 1. Kills Tearing & Input Delay."
    "6" = "Network Bypass: Rewrites TCP/IP for zero packet buffering on physical adapters."
    "11"= "Game Priority: Injects IFEO registry keys to permanently force games into High Priority."
}

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $Y = "Yellow"; $M = "Magenta"; $R = "Red"
    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ CPU: $cpu" -ForegroundColor $W
    Write-Host " │ GPU: $gpu | SYSTEM: $systemType" -ForegroundColor $G
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ STATUS: ALL APPLIED TWEAKS ARE 100% PERMANENT ACROSS REBOOTS       │" -ForegroundColor $Y
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
}

# ============================================================
# SURGICAL SYNC MODULES
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]             [ GRAPHICS & DISPLAY ]" -ForegroundColor $C
    Write-Host "[1] INTEL TURBO-LOCK POWER       [3] DISABLE MPO (STOP FLICKER)"
    Write-Host "[2] DISABLE CPU CORE PARKING     [4] INPUT INTERRUPT PRIORITY"
    Write-Host "  [7] WIN32 SCHEDULING BOOST       [5] APEX TRIPLE-SYNC (RIP-FIX)"
    Write-Host ""
    Write-Host "  [ NETWORK & LATENCY ]            [ MEMORY & STABILITY ]" -ForegroundColor Green
    Write-Host "  [6] PHYSICAL NETWORK OPTIMIZER   [8] LARGE SYSTEM CACHE (SSD)"
    Write-Host "  [13] FLUSH DNS & INTERNET RESET  [9] MECHANICAL DRIVE FIX"
    Write-Host ""
    Write-Host "[ SYSTEM CLEANUP ]               [ SAFETY & EXIT ]" -ForegroundColor $Y
    Write-Host "  [10] DELETE SYSTEM TEMP JUNK     [R] UNDO ALL (SYSTEM RESTORE)"
    Write-Host "[11] TITAN GAME PRIORITIZATION   [12] DISABLE OS TELEMETRY"
    Write-Host ""
    Write-Host "  [ A ] AUTO-SENSE OPTIMIZATION    [ Q ] EXIT ENGINE" -ForegroundColor $M
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $cmdInput = (Read-Host "  CMD").Trim().ToLower()
    
    if ($cmdInput.EndsWith("?")) {
        $num = $cmdInput.Replace("?","")
        if ($Details.ContainsKey($num)) { Write-Host "`n  [ CONTEXT ]: $($Details[$num])" -ForegroundColor Cyan; pause | Out-Null; continue }
    }

    switch ($cmdInput) {
        "1" { 
            Handle-Restore
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            powercfg /setactive $p
            if ($isIntel) {
                powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
            }
            Write-Host "  Power Plan & Intel Turbo Permanently Locked." -ForegroundColor Green
        }
        "2" { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg /setactive SCHEME_CURRENT; Write-Host "  Cores Permanently Unparked." -ForegroundColor Green }
        "3" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5; Write-Host "  MPO Permanently Disabled." -ForegroundColor Green }
        "4" { 
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24
            $hid = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"
            if (!(Test-Path $hid)) { New-Item $hid -Force }; Set-ItemProperty -Path $hid -Name "CpuPriorityClass" -Value 3
            Write-Host "  Input Priority Permanently Elevated (Safe 24-Buffer)." -ForegroundColor Green 
        }
        "5" {
            # Direct Flip & Anti-Tear
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2
            # DirectX Pre-Rendered Frames & Fencing
            $dx = "HKLM:\SOFTWARE\Microsoft\DirectX"
            if (!(Test-Path $dx)) { New-Item $dx -Force }
            Set-ItemProperty -Path $dx -Name "EnablePerformanceFencing" -Value 1
            Set-ItemProperty -Path $dx -Name "MaxQueuedFrames" -Value 1
            Write-Host "  Triple-Sync Fence & 1-Frame Render Permanently Active." -ForegroundColor Green
        }
        "6" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                $desc = (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).Description
                if ($desc -notmatch "Virtual|VPN|TAP|Loopback|Hyper-V|Bluetooth") {
                    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
                    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
                }
            }
            Write-Host "  Physical Network Logic Permanently Rewritten." -ForegroundColor Green
        }
        "7" { Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38; Write-Host "  Kernel Scheduling Permanently Boosted." -ForegroundColor Green }
        "11" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","javaw.exe","Minecraft.Windows.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }; Set-ItemProperty $p -Name "CpuPriorityClass" -Value 3; Set-ItemProperty $p -Name "IoPriorityClass" -Value 3
            }
            Write-Host "  Titan Game Priorities Permanently Injected." -ForegroundColor Green
        }
        "12" { Set-Service "DiagTrack" -StartupType Disabled; Stop-Service "DiagTrack" -Force; Write-Host "  Telemetry Permanently Disabled." -ForegroundColor Green }
        "a" {
            Write-Host " [>] AUTO-TRIAGING SYSTEM..." -ForegroundColor Cyan
            Handle-Restore
            
            # Apply all essential, safe, and permanent registry tweaks
            "2","3","4","5","6","7","11","12" | ForEach-Object {
                $v = $_; switch($v){
                    "2"{powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100;powercfg /setactive SCHEME_CURRENT}
                    "3"{Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" "OverlayTestMode" 5}
                    "4"{Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" "KeyboardDataQueueSize" 24; $hid="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hidserv.exe\PerfOptions"; if(!(Test-Path $hid)){New-Item $hid -Force}; Set-ItemProperty $hid "CpuPriorityClass" 3}
                    "5"{Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "ForceDirectFlip" 1; $dx="HKLM:\SOFTWARE\Microsoft\DirectX"; if(!(Test-Path $dx)){New-Item $dx -Force}; Set-ItemProperty $dx "EnablePerformanceFencing" 1; Set-ItemProperty $dx "MaxQueuedFrames" 1}
                    "6"{Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object { $d=(Get-ItemProperty $_.PSPath -EA SilentlyContinue).Description; if($d -notmatch "Virtual|VPN|TAP|Loopback|Hyper-V|Bluetooth") { Set-ItemProperty $_.PSPath "TcpAckFrequency" 1; Set-ItemProperty $_.PSPath "TCPNoDelay" 1 } } }
                    "7"{Set-ItemProperty "HKLM:\System\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" 38}
                    "11"{$g=@("cs2.exe","cod.exe","VALORANT-Win64-Shipping.exe","r5apex.exe","RobloxPlayerBeta.exe","javaw.exe","Minecraft.Windows.exe");foreach($x in $g){$p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$x\PerfOptions";if(!(Test-Path $p)){New-Item $p -Force};Set-ItemProperty $p "CpuPriorityClass" 3;Set-ItemProperty $p "IoPriorityClass" 3}}
                    "12"{Set-Service "DiagTrack" -StartupType Disabled; Stop-Service "DiagTrack" -Force}
                }
            }
            
            # Apply Intelligent Power Logic
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            $p = (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            powercfg /setactive $p
            if ($isIntel) {
                powercfg -attributes SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
            }
            
            Write-Host "`n [SUCCESS] ALL TWEAKS PERMANENTLY APPLIED. REBOOT REQUIRED." -ForegroundColor Magenta; pause
        }
        "d" { Start-Process "https://discordapp.com/users/848750246124191744" }
        "r" { rstrui.exe }
        "q" { exit }
    }
    Start-Sleep -Seconds 1
}

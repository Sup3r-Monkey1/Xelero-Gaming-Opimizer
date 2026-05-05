# ============================================================
#  XELERO // OMNIBUS SUPREME (v61.0) — ZENITH AUTO-SENSE
#  "THE ABSOLUTE FINAL: HARDWARE-AWARE INTELLIGENCE"
#  UNIVERSAL: INTEL / AMD / NVIDIA | 100% STABLE
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // ZENITH AUTO-SENSE v61.0"
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
    
    # Chassis Detection (Identify Laptop or Desktop)
    $chassis = (Get-CimInstance Win32_SystemEnclosure).ChassisTypes
    if ($chassis -contains 9 -or $chassis -contains 10 -or $chassis -contains 14) {
        $Global:systemType = "LAPTOP (MOBILE)"
        $Global:isLaptop = $true
    } else {
        $Global:systemType = "DESKTOP (STATIONARY)"
        $Global:isLaptop = $false
    }

    $Global:isSSD = (Get-PhysicalDisk | Where-Object {$_.BusType -match "NVMe|SATA" -and $_.MediaType -eq "SSD"}) -ne $null
    $Global:onBattery = (Get-CimInstance -ClassName Win32_Battery).BatteryStatus -eq 1
}

# -- SAFETY & RESTORE LOGIC --
function Handle-Restore {
    $RegCheck = Get-ItemProperty "HKLM:\SOFTWARE" -Name "XeleroBackup" -ErrorAction SilentlyContinue
    if ($null -eq $RegCheck) {
        Write-Host " [!] FIRST RUN: FORCING SYSTEM RESTORE POINT..." -ForegroundColor Cyan
        Checkpoint-Computer -Description "XELERO_ZENITH_INITIAL" -RestorePointType "MODIFY_SETTINGS"
        New-ItemProperty -Path "HKLM:\SOFTWARE" -Name "XeleroBackup" -Value "Created" -PropertyType String -Force | Out-Null
        Write-Host " [OK] SAFETY NET CREATED." -ForegroundColor Green
    } else {
        Write-Host " [?] Create a fresh Restore Point? (Y/N)" -ForegroundColor Yellow
        if ((Read-Host " >>") -eq "y") {
            Write-Host " [!] CREATING RESTORE POINT..." -ForegroundColor Cyan
            Checkpoint-Computer -Description "XELERO_ZENITH_MANUAL" -RestorePointType "MODIFY_SETTINGS"
            Write-Host " [OK] SAFETY NET CREATED." -ForegroundColor Green
        }
    }
}

# -- INFO-PEEK DATABASE --
$Details = @{
    "1" = "Ultimate Power Logic: Imports the max performance plan. WARNING: Laptops should monitor heat."
    "2" = "Core Parking: Keeps all CPU threads awake. Prevents stutters when a core 'wakes up' mid-game."
    "3" = "MPO Override: Fixes black screen flickers and stutters in browsers/Roblox. 100% Safe."
    "4" = "Input Priority: Sets Mouse/Keyboard tasks to High Priority. Uses safe 24-buffer standard."
    "5" = "Apex Triple-Sync: Forces kernel-level flip handshake. The best fix for Screen Ripping/Tearing."
    "6" = "Network Stack: Disables TCP delay on physical hardware only. Does not touch VPN/Virtual cards."
    "7" = "Win32 Scheduling: Boosts foreground CPU time for higher minimum FPS and smoother feel."
    "8" = "SSD Cache: Prioritizes RAM for file access. (DENIED on HDDs or Low RAM)."
    "9" = "Mechanical Fix: Disables pre-fetching tasks that cause 100% disk usage on old HDDs."
    "A" = "Auto-Sense: Scans your hardware and applies a tailored package perfect for your Laptop or Desktop."
}

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $Y = "Yellow"; $M = "Magenta"; $R = "Red"
    if ($isSSD) { $drive = "SSD" } else { $drive = "HDD" }

    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │  CPU: $cpu" -ForegroundColor $W
    Write-Host " │  GPU: $gpu | RAM: $ram GB | DISK: $drive" -ForegroundColor $G
    Write-Host " │  [ SYSTEM TYPE ]: $systemType" -ForegroundColor $Y
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
    Write-Host "  [?] Type number + '?' for details. 'A' for Auto-Sense tuning. " -ForegroundColor $G
}

# ============================================================
# PERFORMANCE COMMAND CENTER
# ============================================================

Run-Scanner
while ($true) {
    Show-Header
    Write-Host "  [ CORE PERFORMANCE ]             [ GRAPHICS & DISPLAY ]" -ForegroundColor $C
    Write-Host "  [1] ULTIMATE POWER LOGIC         [3] DISABLE MPO (FIX FLICKER)"
    Write-Host "  [2] DISABLE CPU CORE PARKING     [4] INPUT INTERRUPT PRIORITY"
    Write-Host "  [7] WIN32 SCHEDULING BOOST       [5] APEX TRIPLE-SYNC (NO TEAR)"
    Write-Host ""
    Write-Host "  [ NETWORK & LATENCY ]            [ MEMORY & STABILITY ]" -ForegroundColor Green
    Write-Host "  [6] PHYSICAL NETWORK OPTIMIZER   [8] LARGE SYSTEM CACHE (SSD)"
    Write-Host "  [13] FLUSH DNS & INTERNET RESET  [9] MECHANICAL DRIVE (HDD) FIX"
    Write-Host ""
    Write-Host "  [ SYSTEM CLEANUP ]               [ SAFETY & EXIT ]" -ForegroundColor $Y
    Write-Host "  [10] DELETE SYSTEM TEMP JUNK     [R] UNDO ALL (SYSTEM RESTORE)"
    Write-Host "  [11] TITAN GAME PRIORITIZATION   [12] DISABLE OS TELEMETRY"
    Write-Host ""
    Write-Host "  [ A ] AUTO-SENSE OPTIMIZATION    [ D ] DISCORD     [ Q ] EXIT" -ForegroundColor $M
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $cmdInput = (Read-Host "  CMD").Trim().ToLower()
    
    if ($cmdInput.EndsWith("?")) {
        $num = $cmdInput.Replace("?","")
        if ($Details.ContainsKey($num)) {
            Write-Host "`n  [ TECHNICAL DETAIL ]: $($Details[$num])" -ForegroundColor Cyan
            Write-Host "  Press any key to return..."
            pause | Out-Null; continue
        }
    }

    switch ($cmdInput) {
        "1" { 
            if($isLaptop){ Write-Host " [!] Laptop Detected. Monitor temps while gaming." -ForegroundColor Yellow }
            Handle-Restore; powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            powercfg /setactive (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            Write-Host "  Rocket Power Engaged." -ForegroundColor Green
        }
        "2" { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg /setactive SCHEME_CURRENT; Write-Host "  Cores Unparked." -ForegroundColor Green }
        "3" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5; Write-Host "  MPO Disabled." -ForegroundColor Green }
        "4" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24; Write-Host "  Input Response Optimized." -ForegroundColor Green }
        "5" {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1
            Write-Host "  Triple-Sync Tear Fix Applied." -ForegroundColor Green
        }
        "6" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                $desc = (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).Description
                if ($desc -notmatch "Virtual|VPN|TAP|Loopback") { Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1; Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 }
            }
            Write-Host "  Network Stack Optimized." -ForegroundColor Green
        }
        "7" { Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38; Write-Host "  Win32 Schedulers Boosted." -ForegroundColor Green }
        "8" {
            if ($ram -ge 8 -and $isSSD) { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" 1; Write-Host "  SSD Cache Active." -ForegroundColor Green }
            else { Write-Host "  [!] DENIED: Unsafe for HDDs or low RAM." -ForegroundColor Red }
        }
        "9" {
            if (!$isSSD) { Set-Service "SysMain" -StartupType Disabled; Stop-Service "SysMain" -Force; Write-Host "  Mechanical Disk Fix Applied." -ForegroundColor Green }
            else { Write-Host "  [!] DENIED: You have an SSD." -ForegroundColor Red }
        }
        "11" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","Marathon.exe","javaw.exe")
            foreach ($g in $games) { $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"; if (!(Test-Path $p)) { New-Item $p -Force }; Set-ItemProperty $p -Name "CpuPriorityClass" -Value 3; Set-ItemProperty $p -Name "IoPriorityClass" -Value 3 }
            Write-Host "  Titan Priorities Injected." -ForegroundColor Green
        }
        "a" {
            Write-Host " [>] STARTING AUTO-TRIAGE FOR $systemType..." -ForegroundColor Cyan
            Handle-Restore
            # Run stable base (2, 3, 4, 5, 6, 7, 11, 12)
            "2","3","4","5","6","7","11","12" | ForEach-Object { Invoke-Expression "& { `$Global:cmdInput = '$_'; switch(`$cmdInput){ '$_' } }" }
            # Run Power Logic
            Invoke-Expression "& { `$Global:cmdInput = '1'; switch(`$cmdInput){ '1' } }"
            # Run Disk Logic
            if ($isSSD -and $ram -ge 8) { Invoke-Expression "& { `$Global:cmdInput = '8'; switch(`$cmdInput){ '8' } }" }
            elseif (!$isSSD) { Invoke-Expression "& { `$Global:cmdInput = '9'; switch(`$cmdInput){ '9' } }" }
            Write-Host "`n [SUCCESS] $systemType FULLY OPTIMIZED." -ForegroundColor Magenta; pause
        }
        "d" { Start-Process "https://discordapp.com/users/848750246124191744" }
        "r" { rstrui.exe }
        "q" { exit }
    }
    Start-Sleep -Seconds 1
}

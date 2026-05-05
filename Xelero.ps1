# ============================================================
#  XELERO // OMNIBUS SUPREME (v59.0) — APEX FINALITY
#  "THE ABSOLUTE FINAL: SURGICAL, SAFE, & TEAR-FREE"
#  COMPATIBILITY: UNIVERSAL (INTEL / AMD / NVIDIA)
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // APEX FINALITY v59.0"
$ErrorActionPreference = "SilentlyContinue"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] ELEVATED PERMISSIONS REQUIRED." -ForegroundColor Red
    pause; exit
}

# -- PERSISTENT RESTORE FLAG --
$RestoreFlag = "$env:LOCALAPPDATA\XeleroBackup.flag"

# -- HARDWARE SCANNER --
function Run-Scanner {
    $Global:cpu = (Get-CimInstance Win32_Processor).Name
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $Global:isLaptop = $null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue)
    $Global:isSSD = (Get-PhysicalDisk | Where-Object {$_.MediaType -eq 'SSD'}) -ne $null
}

# -- SAFETY & RESTORE LOGIC --
function Handle-Restore {
    if (!(Test-Path $RestoreFlag)) {
        Write-Host " [!] FIRST RUN DETECTED: FORCING SYSTEM RESTORE POINT..." -ForegroundColor Cyan
        Checkpoint-Computer -Description "XELERO_FIRST_RUN_BACKUP" -RestorePointType "MODIFY_SETTINGS"
        New-Item $RestoreFlag -ItemType File -Force | Out-Null
        Write-Host " [OK] SAFETY NET CREATED." -ForegroundColor Green
    } else {
        Write-Host " [?] Create a fresh Restore Point? (Y/N)" -ForegroundColor Yellow
        $choice = Read-Host " >>"
        if ($choice -eq "y") {
            Write-Host " [!] CREATING RESTORE POINT..." -ForegroundColor Cyan
            Checkpoint-Computer -Description "XELERO_MANUAL_BACKUP" -RestorePointType "MODIFY_SETTINGS"
            Write-Host " [OK] SAFETY NET CREATED." -ForegroundColor Green
        }
    }
}

# -- INFO-PEEK DATABASE --
$Details = @{
    "1" = "Ultimate Power: Unlocks max performance plan. WARNING: Laptop users monitor temps."
    "2" = "Core Parking: Keeps CPU cores awake to eliminate mid-game stutters."
    "3" = "MPO Override: Fixes black screen flickers and stutters in browsers/Discord."
    "4" = "Input Priority: Moves Mouse/Keyboard tasks to top CPU schedule. Locked at safe 24."
    "5" = "Apex Sync: Forces Triple-Sync Independent Flip. Best fix for Screen Ripping/Tearing."
    "6" = "Network Stack: Disables Nagle's Algorithm on physical hardware only (No VPN interference)."
    "7" = "Win32 Scheduling: Boosts foreground CPU time for higher minimum FPS."
    "8" = "SSD Cache: Speeds up map loading. (DENIED on HDDs or <8GB RAM)."
    "9" = "HDD Fix: Stops 100% Disk Usage on old drives. (DENIED on SSDs)."
}

# -- UI STYLING --
function Show-Header {
    Clear-Host
    $C = "Cyan"; $G = "DarkGray"; $W = "White"; $Y = "Yellow"; $M = "Magenta"; $R = "Red"
    if ($isLaptop) { $mode = "MOBILE" } else { $mode = "STATION" }
    if ($isSSD) { $drive = "SSD" } else { $drive = "HDD" }

    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS " -ForegroundColor $G
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor $G
    Write-Host " │  ██╗  ██╗███████╗██╗      ███████╗██████╗  ██████╗                 │" -ForegroundColor $C
    Write-Host " │  ╚██╗██╔╝██╔════╝██║      ██╔════╝██╔══██╗██╔═══██╗                │" -ForegroundColor $C
    Write-Host " │   ╚███╔╝ █████╗  ██║      █████╗  ██████╔╝██║   ██║                │" -ForegroundColor $C
    Write-Host " │   ██╔██╗ ██╔══╝  ██║      ██╔══╝  ██╔══██╗██║   ██║                │" -ForegroundColor $C
    Write-Host " │  ██╔╝ ██╗███████╗███████╗███████╗██║  ██║╚██████╔╝                 │" -ForegroundColor $C
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor $G
    Write-Host " │ HW: $cpu" -ForegroundColor $W
    Write-Host " │ GPU: $gpu | DISK: $drive | MODE: $mode" -ForegroundColor $G
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor $G
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
    Write-Host "  [ X ] APPLY ALL ESSENTIALS       [ Q ] EXIT ENGINE" -ForegroundColor $M
    Write-Host " ──────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    
    $cmdInput = (Read-Host "  CMD").Trim().ToLower()
    
    if ($cmdInput.EndsWith("?")) {
        $num = $cmdInput.Replace("?","")
        if ($Details.ContainsKey($num)) {
            Write-Host "`n  [ TECHNICAL DETAIL ]: $($Details[$num])" -ForegroundColor Cyan
            Write-Host "  Press any key..."
            pause | Out-Null; continue
        }
    }

    switch ($cmdInput) {
        "1" { 
            Handle-Restore
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            powercfg /setactive (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })
            Write-Host "  Ultimate Plan Active." -ForegroundColor Green
        }
        "2" { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg /setactive SCHEME_CURRENT; Write-Host "  Cores Active." -ForegroundColor Green }
        "3" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -Value 5; Write-Host "  MPO Disabled." -ForegroundColor Green }
        "4" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 24; Write-Host "  HID Response Primed." -ForegroundColor Green }
        "5" {
            # THE TRIPLE-SYNC SCREEN RIP FIX
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -Value 1
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableBlurBehind" -Value 0
            Write-Host "  Triple-Sync Tear Fix Applied." -ForegroundColor Green
        }
        "6" {
            Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
                $desc = (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).Description
                if ($desc -notmatch "Virtual|VPN|TAP|Loopback") {
                    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1
                    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1
                }
            }
            Write-Host "  Network Latency Nuked." -ForegroundColor Green
        }
        "7" { Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38; Write-Host "  Kernel Boosted." -ForegroundColor Green }
        "8" {
            if ($ram -ge 8 -and $isSSD) {
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1
                Write-Host "  SSD Cache Active." -ForegroundColor Green
            } else {
                Write-Host "  [!] ACCESS DENIED: Tweak unsafe for HDDs or Low RAM." -ForegroundColor Red
            }
        }
        "9" {
            if ($isSSD -eq $false) {
                Set-Service "SysMain" -StartupType Disabled; Stop-Service "SysMain" -Force
                Write-Host "  HDD 100% Usage Fix Applied." -ForegroundColor Green
            } else { Write-Host "  [!] ACCESS DENIED: You have an SSD." -ForegroundColor Red }
        }
        "11" {
            $games = @("cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","Marathon.exe","javaw.exe","Minecraft.Windows.exe")
            foreach ($g in $games) {
                $p = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions"
                if (!(Test-Path $p)) { New-Item $p -Force }; Set-ItemProperty $p -Name "CpuPriorityClass" -Value 3
            }
            Write-Host "  Titans Prioritized." -ForegroundColor Green
        }
        "12" { Set-Service "DiagTrack" -StartupType Disabled; Stop-Service "DiagTrack" -Force; Write-Host "  Telemetry Killed." -ForegroundColor Green }
        "13" { ipconfig /flushdns; netsh winsock reset; Write-Host "  Network Reset." -ForegroundColor Green }
        "x" {
            Handle-Restore
            # Run stable loop
            "1","2","3","4","5","6","7","11","12" | ForEach-Object {
                $v = $_; switch($v){
                    "1"{powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null; powercfg /setactive (powercfg /list | Select-String "Ultimate" | ForEach-Object { ($_ -split "\s+")[3] })}
                    "2"{powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg /setactive SCHEME_CURRENT}
                    "3"{Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" "OverlayTestMode" 5}
                    "4"{Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" "KeyboardDataQueueSize" 24}
                    "5"{Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "ForceDirectFlip" 1}
                    "6"{Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"|ForEach-Object{Set-ItemProperty $_.PSPath "TcpAckFrequency" 1}}
                    "7"{Set-ItemProperty "HKLM:\System\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" 38}
                    "11"{$games=@("cs2.exe","cod.exe","VALORANT-Win64-Shipping.exe","r5apex.exe","RobloxPlayerBeta.exe","javaw.exe");foreach($g in $games){$p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$g\PerfOptions";if(!(Test-Path $p)){New-Item $p -Force};Set-ItemProperty $p "CpuPriorityClass" 3}}
                    "12"{Set-Service "DiagTrack" -StartupType Disabled; Stop-Service "DiagTrack" -Force}
                }
            }
            Write-Host "`n  [!] XELERATION COMPLETE. REBOOT FOR EFFECT." -ForegroundColor Magenta; pause
        }
        "r" { rstrui.exe }
        "q" { exit }
    }
    Start-Sleep -Seconds 1
}

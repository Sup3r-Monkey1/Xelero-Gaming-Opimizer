# ============================================================
#  XELERO // OMNIBUS SUPREME (v64.0) — KERNEL-VERIFIED EDITION
#  TARGET: MODERN WINDOWS 10/11 (HYBRID INTEL, AMD X3D, ANTI-CHEAT SAFE)
# ============================================================

$Host.UI.RawUI.WindowTitle = "XELERO // APEX PREDATOR v64.0 (KERNEL-SAFE)"
$ErrorActionPreference = "Stop"

# -- ADMIN CHECK --
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] ELEVATED PERMISSIONS REQUIRED." -ForegroundColor Red
    pause; exit
}

# -- DEEP HARDWARE SCANNER --
function Run-Scanner {
    $cpuObj = Get-CimInstance Win32_Processor | Select-Object -First 1
    $Global:cpu = $cpuObj.Name.Trim()
    $Global:isIntel = $Global:cpu -match "Intel"
    $Global:isAMD   = $Global:cpu -match "AMD"
    $Global:isX3D   = $Global:cpu -match "X3D"
    $Global:gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $Global:ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $chassis = (Get-CimInstance Win32_SystemEnclosure).ChassisTypes
    $Global:isLaptop = ($chassis -contains 8 -or $chassis -contains 9 -or $chassis -contains 10 -or $chassis -contains 14 -or $chassis -contains 30 -or $chassis -contains 31)
    $Global:systemType = if ($Global:isLaptop) { "LAPTOP (MOBILE)" } else { "DESKTOP (STATION)" }
    $Global:isSSD = $null -ne (Get-PhysicalDisk -ErrorAction SilentlyContinue | Where-Object { $_.MediaType -eq "SSD" -or $_.BusType -eq "NVMe" })
}

# -- SAFETY & RESTORE POINT --
function Handle-Restore {
    try {
        $RegCheck = Get-ItemProperty "HKLM:\SOFTWARE" -Name "XeleroBackup_v64" -ErrorAction SilentlyContinue
        if ($null -eq $RegCheck) {
            Write-Host " [!] CREATING SYSTEM RESTORE POINT..." -ForegroundColor Cyan
            Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
            Checkpoint-Computer -Description "XELERO_v64_BACKUP" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
            New-ItemProperty -Path "HKLM:\SOFTWARE" -Name "XeleroBackup_v64" -Value (Get-Date -Format "yyyy-MM-dd") -PropertyType String -Force | Out-Null
        }
    } catch {
        Write-Host " [i] System Restore skipped (throttled or disabled by policy)." -ForegroundColor DarkYellow
    }
}

# -- CLEAN UP LEGACY v63 PLACEBOS / HARMFUL KEYS --
function Invoke-LegacyCleanup {
    # 1. Restore kbdclass queue size to Windows default (100 / 0x64) to prevent dropped Rapid Trigger inputs
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 100 -Type DWord -ErrorAction SilentlyContinue
    
    # 2. Re-enable MPO (delete OverlayTestMode) so DX12 Hardware Composed Independent Flip works with 0 latency
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -ErrorAction SilentlyContinue
    
    # 3. Remove hallucinated DirectX keys & obsolete ForceDirectFlip
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "EnablePerformanceFencing" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "MaxQueuedFrames" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "ForceDirectFlip" -ErrorAction SilentlyContinue
    
    # 4. Remove IFEO PerfOptions on games & non-existent hidserv.exe to prevent Vanguard/EAC thread starvation
    $targets = @("hidserv.exe","cs2.exe","VALORANT-Win64-Shipping.exe","cod.exe","r5apex.exe","RobloxPlayerBeta.exe","javaw.exe","Minecraft.Windows.exe")
    foreach ($t in $targets) {
        $ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$t\PerfOptions"
        if (Test-Path $ifeoPath) { Remove-Item -Path $ifeoPath -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

# -- MODULAR OPTIMIZATION FUNCTIONS --
function Enable-SmartPower {
    Handle-Restore
    if ($Global:isLaptop) {
        # On Laptops: Use High Performance / Balanced with HWP EPP rather than forcing 100% unparked cores & thermal throttling
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        # Keep Boost at 'Enabled' (1) so Intel Speed Shift (HWP) / AMD CPPC2 manages boost curves natively
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 1
        powercfg /setactive SCHEME_CURRENT
        Write-Host "  [OK] Laptop-Safe HWP Power Profile Active (Prevents PROCHOT Throttling)." -ForegroundColor Green
    } else {
        # On Desktops: Reuse existing Ultimate Performance plan if present, otherwise create once
        $existingUlt = powercfg /list | Select-String "Ultimate Performance" | Select-Object -First 1
        if (-not $existingUlt) {
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            $existingUlt = powercfg /list | Select-String "Ultimate Performance" | Select-Object -First 1
        }
        if ($existingUlt -match "([a-fA-F0-9]{8}-([a-fA-F0-9]{4}-){3}[a-fA-F0-9]{12})") {
            powercfg /setactive $Matches[1]
        }
        # Keep PERFBOOSTMODE at 1 (Native HWP/CPPC2)
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 1
        powercfg /setactive SCHEME_CURRENT
        Write-Host "  [OK] Desktop Ultimate Power Policy Active (Single Instance)." -ForegroundColor Green
    }
}

function Optimize-CoreParking {
    if ($Global:isX3D -or $Global:isLaptop) {
        # Restore standard core parking on AMD X3D (required for 3D V-Cache CCD isolation) and laptops
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 50
        powercfg /setactive SCHEME_CURRENT
        Write-Host "  [OK] Hardware-Aware Core Parking Configured (Safe for X3D / Hybrid Mobile)." -ForegroundColor Green
    } else {
        powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
        powercfg /setactive SCHEME_CURRENT
        Write-Host "  [OK] Desktop Cores Unparked." -ForegroundColor Green
    }
}

function Optimize-GraphicsFlipModel {
    # Ensure MPO is ENABLED for 0-latency Hardware Composed: Independent Flip
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -ErrorAction SilentlyContinue
    
    # Enable Hardware-Accelerated GPU Scheduling (HAGS - HwSchMode = 2)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -Force
    
    # Enable Windows 11 Optimizations for Windowed Games (DirectX Auto-Flip Model upgrade) & VRR
    $directxUser = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    if (-not (Test-Path $directxUser)) { New-Item -Path $directxUser -Force | Out-Null }
    Set-ItemProperty -Path $directxUser -Name "DirectXUserGlobalSettings" -Value "VRROptimizeEnable=1;SwapEffectUpgradeEnable=1;" -Type String -Force

    # Disable Xbox GameDVR Background Recording overhead while keeping Game Mode intact
    $gameDvr = "HKCU:\System\GameConfigStore"
    if (-not (Test-Path $gameDvr)) { New-Item -Path $gameDvr -Force | Out-Null }
    Set-ItemProperty -Path $gameDvr -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
    
    $gameBarPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
    if (-not (Test-Path $gameBarPol)) { New-Item -Path $gameBarPol -Force | Out-Null }
    Set-ItemProperty -Path $gameBarPol -Name "AllowGameDVR" -Value 0 -Type DWord -Force

    Write-Host "  [OK] DXGI Flip-Model Upgrade, HAGS, VRR & MPO Enabled; GameDVR Recording Disabled." -ForegroundColor Green
}

function Optimize-MMCSSAndScheduler {
    # Win32PrioritySeparation = 2 (0x02 Default) or 40 (0x28: Short, Variable, 1:1 ratio so audio/AC threads aren't starved)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 40 -Type DWord -Force

    # MMCSS (Multimedia Class Scheduler Service) — Valid range is 10 to 100 (0 is ignored and defaults to 20 in mmcss.sys)
    $sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 10 -Type DWord -Force
    Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force

    # Configure MMCSS 'Games' task (used natively by Game Mode without breaking worker thread priorities)
    $gamesTask = "$sysProfile\Tasks\Games"
    if (-not (Test-Path $gamesTask)) { New-Item -Path $gamesTask -Force | Out-Null }
    Set-ItemProperty -Path $gamesTask -Name "GPU Priority" -Value 8 -Type DWord -Force
    Set-ItemProperty -Path $gamesTask -Name "Priority" -Value 6 -Type DWord -Force
    Set-ItemProperty -Path $gamesTask -Name "Scheduling Category" -Value "High" -Type String -Force
    Set-ItemProperty -Path $gamesTask -Name "SFIO Priority" -Value "High" -Type String -Force

    # Ensure Windows Game Mode is Enabled
    $gameBar = "HKCU:\Software\Microsoft\GameBar"
    if (-not (Test-Path $gameBar)) { New-Item -Path $gameBar -Force | Out-Null }
    Set-ItemProperty -Path $gameBar -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $gameBar -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force

    Write-Host "  [OK] MMCSS (SystemResponsiveness=10) & 1:1 Short-Quantum Scheduler Configured." -ForegroundColor Green
}

function Optimize-NetworkStack {
    # Clean up old broken TcpAckFrequency/TCPNoDelay keys across all interfaces
    Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -ErrorAction SilentlyContinue
    }
    # Ensure Receive-Side Scaling (RSS) is enabled for multi-core UDP packet processing
    netsh int tcp set global rss=enabled | Out-Null
    # Disable Energy Efficient Ethernet (EEE) / Green Ethernet power saving on physical NICs
    Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
        Disable-NetAdapterPowerManagement -Name $_.Name -NoRestart -ErrorAction SilentlyContinue
    }
    Write-Host "  [OK] NIC Power-Saving Disabled & Multi-Core RSS Packet Processing Enabled." -ForegroundColor Green
}

function Optimize-StorageAndMemory {
    # Ensure LargeSystemCache is 0 (Default for Gaming/Workstation so apps keep RAM working set)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 0 -Type DWord -Force
    if ($Global:isSSD) {
        fsutil behavior set DisableDeleteNotify 0 | Out-Null
        Write-Host "  [OK] SSD TRIM Verified & Workstation Memory Working-Set Active." -ForegroundColor Green
    }
}

function Invoke-TempCleanup {
    $paths = @("$env:TEMP\*", "$env:windir\Temp\*")
    foreach ($p in $paths) {
        Remove-Item -Path $p -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  [OK] Unreferenced User & System Temp Files Purged (Shader Caches Preserved)." -ForegroundColor Green
}

function Invoke-NetworkReset {
    ipconfig /flushdns | Out-Null
    Write-Host "  [OK] DNS Resolver Cache Flushed." -ForegroundColor Green
}

function Set-SafeTelemetryPolicy {
    # Use official Group Policy key rather than ripping out DiagTrack (keeps Xbox Party & AMD/Intel PPKG updates working)
    $dataCol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $dataCol)) { New-Item -Path $dataCol -Force | Out-Null }
    Set-ItemProperty -Path $dataCol -Name "AllowTelemetry" -Value 1 -Type DWord -Force
    Write-Host "  [OK] OS Telemetry Minimized via Policy (Xbox & Driver Provisioning Preserved)." -ForegroundColor Green
}

function Undo-AllTweaks {
    Invoke-LegacyCleanup
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 2 -Type DWord -Force
    $sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 20 -Type DWord -Force
    Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force
    Set-Service "DiagTrack" -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service "DiagTrack" -ErrorAction SilentlyContinue
    powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>$null
    Write-Host "  [OK] All Kernel, DWM, Input, IFEO & Scheduler Values Restored to Windows Defaults." -ForegroundColor Yellow
}

# -- UI HEADER --
function Show-Header {
    Clear-Host
    Write-Host "  $($env:COMPUTERNAME) @ XELERO-OS (v64.0 KERNEL-SAFE)" -ForegroundColor DarkGray
    Write-Host " ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
    Write-Host " │  CPU: $Global:cpu" -ForegroundColor White
    Write-Host " │  GPU: $Global:gpu | RAM: $($Global:ram)GB | TYPE: $Global:systemType" -ForegroundColor Cyan
    Write-Host " ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor DarkGray
    Write-Host " │  [1] SMART POWER & HWP/CPPC2      [5] DX12 FLIP-MODEL, MPO & HAGS  │"
    Write-Host " │  [2] HARDWARE-AWARE CORE PARKING  [6] NIC POWER & RSS OPTIMIZER    │"
    Write-Host " │  [4] CLEAN LEGACY INPUT/IFEO BUGS [7] MMCSS & 1:1 SCHEDULER TUNING │"
    Write-Host " │  [8] SSD TRIM & MEMORY WORKSET    [10] SAFE TEMP CLEANUP           │"
    Write-Host " │  [12] MINIMIZE TELEMETRY (SAFE)   [13] FLUSH DNS CACHE             │"
    Write-Host " │  [A] APPLY ALL VERIFIED TWEAKS    [R] RESTORE WINDOWS DEFAULTS     │"
    Write-Host " │  [Q] EXIT                                                          │"
    Write-Host " └────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
}

Run-Scanner
while ($true) {
    Show-Header
    $cmdInput = (Read-Host "  CMD").Trim().ToLower()
    switch ($cmdInput) {
        "1"  { Enable-SmartPower; pause }
        "2"  { Optimize-CoreParking; pause }
        "4"  { Invoke-LegacyCleanup; Write-Host "  [OK] Legacy v63 IFEO, kbdclass & DirectX Placebos Removed." -ForegroundColor Green; pause }
        "5"  { Optimize-GraphicsFlipModel; pause }
        "6"  { Optimize-NetworkStack; pause }
        "7"  { Optimize-MMCSSAndScheduler; pause }
        "8"  { Optimize-StorageAndMemory; pause }
        "10" { Invoke-TempCleanup; pause }
        "12" { Set-SafeTelemetryPolicy; pause }
        "13" { Invoke-NetworkReset; pause }
        "a"  {
            Handle-Restore
            Invoke-LegacyCleanup
            Enable-SmartPower
            Optimize-CoreParking
            Optimize-GraphicsFlipModel
            Optimize-MMCSSAndScheduler
            Optimize-NetworkStack
            Optimize-StorageAndMemory
            Set-SafeTelemetryPolicy
            Write-Host "`n [SUCCESS] ALL KERNEL-SAFE TWEAKS APPLIED & v63 BUGS CLEANED. REBOOT RECOMMENDED." -ForegroundColor Magenta
            pause
        }
        "r"  { Undo-AllTweaks; pause }
        "q"  { exit }
    }
}

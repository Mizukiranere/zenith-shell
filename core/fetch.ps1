# ==============================================================================
# Zenith Shell - Hardware & System Specs Fetcher for PowerShell
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

function global:Show-ZenithFetch {
    $e = [char]27
    $theme = if (Get-Command Get-ZenithActiveTheme -ErrorAction SilentlyContinue) { Get-ZenithActiveTheme } else { "cyberpunk" }

    # Query Hardware & System Specs
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        $cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
        $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
    } catch {}

    $user = $env:USERNAME
    $computer = $env:COMPUTERNAME
    $osName = if ($os.Caption) { $os.Caption.Trim() } else { "Windows ($([Environment]::OSVersion.Version))" }
    $arch = if ($os.OSArchitecture) { $os.OSArchitecture } else { "64-bit" }
    $model = if ($cs.Manufacturer -and $cs.Model) { "$($cs.Manufacturer) $($cs.Model)".Trim() } else { "Standard System" }
    $cpuName = if ($cpu.Name) { $cpu.Name.Trim() -replace '\s+', ' ' } else { "Processor" }
    $cpuCores = if ($cpu.NumberOfCores) { "$($cpu.NumberOfCores) Cores" } else { "" }

    # RAM calculation & Visual Bar
    $totalRamMb = [math]::Round($os.TotalVisibleMemorySize / 1KB, 0)
    $freeRamMb = [math]::Round($os.FreePhysicalMemory / 1KB, 0)
    $usedRamMb = $totalRamMb - $freeRamMb
    $ramPercent = if ($totalRamMb -gt 0) { [math]::Round(($usedRamMb / $totalRamMb) * 100, 0) } else { 0 }
    
    $usedRamGb = [math]::Round($usedRamMb / 1024, 2)
    $totalRamGb = [math]::Round($totalRamMb / 1024, 2)

    # Progress bar 10 segments
    $barFilled = [math]::Round($ramPercent / 10, 0)
    $barEmpty = 10 - $barFilled
    if ($barEmpty -lt 0) { $barEmpty = 0 }
    $ramBar = ("=" * $barFilled) + ("-" * $barEmpty)

    # Uptime calculation
    $uptime = if ($os.LastBootUpTime) {
        $ts = New-TimeSpan -Start $os.LastBootUpTime -End (Get-Date)
        "$($ts.Days)d $($ts.Hours)h $($ts.Minutes)m"
    } else { "Available" }

    $shell = "PowerShell $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"

    # Styling colors
    $k = "$e[38;5;141m"       # Label key (purple)
    $v = "$e[38;5;255m"       # Value (white)
    $b = "$e[38;5;51m"        # Zenith Cyan
    $p = "$e[38;5;198m"       # Pink
    $g = "$e[38;5;46m"        # Green
    $y = "$e[38;5;226m"       # Yellow
    $r = "$e[0m"              # Reset

    $palette = "$e[48;5;196m  $e[48;5;208m  $e[48;5;226m  $e[48;5;46m  $e[48;5;51m  $e[48;5;141m  $e[48;5;201m  $r"

    Write-Host ""
    Write-Host "  $b  ______           _ _   _        $r   $p[USER]$r $user@$computer"
    Write-Host "  $b |___  /          (_) | | |       $r   $b--------------------------------------$r"
    Write-Host "  $b    / / ___ _ __   _| |_| |__      $r   $k[OS]    :$r $v$osName ($arch)$r"
    Write-Host "  $b   / / / _ \ '_ \ | | __| '_ \     $r   $k[HOST]  :$r $v$model$r"
    Write-Host "  $b  / /_|  __/ | | || | |_| | | |    $r   $k[CPU]   :$r $v$cpuName $cpuCores$r"
    Write-Host "  $b /_____\___|_| |_||_|\__|_| |_|    $r   $k[RAM]   :$r $g[$ramBar]$r $v$usedRamGb GB / $totalRamGb GB ($ramPercent`%)$r"
    Write-Host "  $p   ⚡ ZENITH SYSTEM SPECS ⚡      $r   $k[UPTIME]:$r $v$uptime$r"
    Write-Host "  $b                                   $r   $k[SHELL] :$r $v$shell$r"
    Write-Host "  $b                                   $r   $k[THEME] :$r $y$theme$r"
    Write-Host "                                       $palette"
    Write-Host ""
}

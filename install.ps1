# ==============================================================================
# Zenith Shell Universal Installer for Windows PowerShell
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

Write-Host @"
  ______           _ _   _        _____ _          _ _ 
 |___  /          (_) | | |      / ____| |        | | |
    / / ___ _ __   _| |_| |__   | (___ | |__   ___| | |
   / / / _ \ '_ \ | | __| '_ \   \___ \| '_ \ / _ \ | |
  / /_|  __/ | | || | |_| | | |  ____) | | | |  __/ | |
 /_____\___|_| |_||_|\__|_| |_| |_____/|_| |_|\___|_|_|
"@ -ForegroundColor Cyan

Write-Host "  Universal Terminal Theme, HUD Prompt & System Specs for PowerShell`n" -ForegroundColor Magenta

$ZenithHome = "$HOME\.zenith"
$RepoUrl = "https://github.com/Mizukiranere/zenith-shell.git"

# Clone or copy
if (Test-Path "$ZenithHome\.git") {
    Write-Host "🔄 Updating existing Zenith Shell installation..." -ForegroundColor Yellow
    & git -C $ZenithHome pull --quiet
} else {
    Write-Host "📥 Installing Zenith Shell to $ZenithHome..." -ForegroundColor Yellow
    if (Test-Path $ZenithHome) { Remove-Item $ZenithHome -Recurse -Force -ErrorAction SilentlyContinue }
    & git clone --depth 1 $RepoUrl $ZenithHome --quiet
}

# Hook into PowerShell Profile
$ProfilePath = $PROFILE
if (-not (Test-Path $ProfilePath)) {
    $ProfileDir = Split-Path $ProfilePath -Parent
    if (-not (Test-Path $ProfileDir)) { New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null }
    New-Item -ItemType File -Force -Path $ProfilePath | Out-Null
}

$HookCommand = "`n# Zenith Shell Prompt Engine`nif (Test-Path `"$ZenithHome\core\zenith.ps1`") { . `"$ZenithHome\core\zenith.ps1`" }`n"

$ProfileContent = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
if ($ProfileContent -notmatch "zenith\.ps1") {
    Add-Content -Path $ProfilePath -Value $HookCommand
    Write-Host "🔗 Added Zenith hook to PowerShell Profile: $ProfilePath" -ForegroundColor Green
}

# Initialize default theme
if (-not (Test-Path "$ZenithHome\current_theme")) {
    Set-Content -Path "$ZenithHome\current_theme" -Value "cyberpunk"
}

# Load immediately in current session
if (Test-Path "$ZenithHome\core\zenith.ps1") {
    . "$ZenithHome\core\zenith.ps1"
}

Write-Host "`n✅ Zenith Shell successfully installed for PowerShell!" -ForegroundColor Green

# Display hardware specs immediately
if (Get-Command Show-ZenithFetch -ErrorAction SilentlyContinue) {
    Show-ZenithFetch
}

Write-Host "👉 Commands:"
Write-Host "   zenith fetch          (show full device & hardware specs)" -ForegroundColor Cyan
Write-Host "   zenith list           (view available themes)" -ForegroundColor Cyan
Write-Host "   zenith set tokyonight (change theme)" -ForegroundColor Cyan
Write-Host "   zenith preview        (preview all theme colors)`n" -ForegroundColor Cyan

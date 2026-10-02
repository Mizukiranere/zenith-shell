# ==============================================================================
# Zenith Shell - Universal Prompt Engine for Windows PowerShell
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$script:ZenithDir = "$HOME\.zenith"
$script:ZenithThemeFile = "$script:ZenithDir\current_theme"

# Import Fetcher Module
$script:CoreDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $script:CoreDir) { $script:CoreDir = "C:\Users\Administrator\Documents\zenith-shell\core" }
$fetchScript = Join-Path $script:CoreDir "fetch.ps1"
if (Test-Path $fetchScript) { . $fetchScript }

function Get-ZenithActiveTheme {
    if (Test-Path $script:ZenithThemeFile) {
        $t = (Get-Content $script:ZenithThemeFile -Raw -ErrorAction SilentlyContinue)
        if ($t) { return $t.Trim() }
    }
    return "cyberpunk"
}

function Get-ZenithColors {
    param([string]$Theme = "cyberpunk")

    $e = [char]27
    switch ($Theme.ToLower()) {
        "tokyonight" {
            return @{
                Frame = "$e[38;5;60m"; Env = "$e[38;5;141m"; User = "$e[38;5;111m"; Dir = "$e[38;5;117m"
                Git = "$e[38;5;215m"; GitDirty = "$e[38;5;203m"; Time = "$e[38;5;103m"
                Success = "$e[38;5;120m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;141m"; Reset = "$e[0m"
            }
        }
        "catppuccin" {
            return @{
                Frame = "$e[38;5;239m"; Env = "$e[38;5;183m"; User = "$e[38;5;217m"; Dir = "$e[38;5;153m"
                Git = "$e[38;5;223m"; GitDirty = "$e[38;5;210m"; Time = "$e[38;5;246m"
                Success = "$e[38;5;150m"; Err = "$e[38;5;203m"; Arrow = "$e[38;5;183m"; Reset = "$e[0m"
            }
        }
        "nord" {
            return @{
                Frame = "$e[38;5;238m"; Env = "$e[38;5;110m"; User = "$e[38;5;109m"; Dir = "$e[38;5;152m"
                Git = "$e[38;5;179m"; GitDirty = "$e[38;5;131m"; Time = "$e[38;5;243m"
                Success = "$e[38;5;108m"; Err = "$e[38;5;131m"; Arrow = "$e[38;5;110m"; Reset = "$e[0m"
            }
        }
        "matrix" {
            return @{
                Frame = "$e[38;5;22m"; Env = "$e[38;5;46m"; User = "$e[38;5;34m"; Dir = "$e[38;5;82m"
                Git = "$e[38;5;118m"; GitDirty = "$e[38;5;196m"; Time = "$e[38;5;28m"
                Success = "$e[38;5;46m"; Err = "$e[38;5;160m"; Arrow = "$e[38;5;46m"; Reset = "$e[0m"
            }
        }
        "dracula" {
            return @{
                Frame = "$e[38;5;60m"; Env = "$e[38;5;141m"; User = "$e[38;5;212m"; Dir = "$e[38;5;117m"
                Git = "$e[38;5;228m"; GitDirty = "$e[38;5;203m"; Time = "$e[38;5;103m"
                Success = "$e[38;5;84m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;212m"; Reset = "$e[0m"
            }
        }
        "minimal" {
            return @{
                Frame = "$e[38;5;238m"; Env = "$e[38;5;244m"; User = "$e[38;5;250m"; Dir = "$e[38;5;255m"
                Git = "$e[38;5;248m"; GitDirty = "$e[38;5;203m"; Time = "$e[38;5;240m"
                Success = "$e[38;5;255m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;250m"; Reset = "$e[0m"
            }
        }
        Default { # Cyberpunk
            return @{
                Frame = "$e[38;5;239m"; Env = "$e[38;5;51m"; User = "$e[38;5;198m"; Dir = "$e[38;5;226m"
                Git = "$e[38;5;201m"; GitDirty = "$e[38;5;196m"; Time = "$e[38;5;245m"
                Success = "$e[38;5;48m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;51m"; Reset = "$e[0m"
            }
        }
    }
}

function Get-ZenithGitBranch {
    $c = Get-ZenithColors (Get-ZenithActiveTheme)
    $gitIcon = "$([char]0x2387)"
    try {
        $b = (& git symbolic-ref --short HEAD 2>$null)
        if (-not $b) {
            $b = (& git describe --tags --always 2>$null)
        }
        if ($b) {
            $status = (& git status --porcelain 2>$null)
            $dirty = if ($status) { "$($c.GitDirty)*" } else { "" }
            return " $($c.Git)$gitIcon $b$dirty$($c.Reset)"
        }
    } catch {}
    return ""
}

function Format-ZenithPath {
    $p = (Get-Location).Path
    $homeDir = [Environment]::GetFolderPath('UserProfile')
    if ($p -eq $homeDir) { return "~" }
    if ($p.StartsWith($homeDir, [System.StringComparison]::OrdinalIgnoreCase)) {
        return "~" + $p.Substring($homeDir.Length).Replace("\", "/")
    }
    return $p.Replace("\", "/")
}

# Override Global PowerShell Prompt (Cyberpunk / Modern HUD style)
function global:prompt {
    $lastSuccess = $?
    $theme = Get-ZenithActiveTheme
    $c = Get-ZenithColors $theme

    $boxTop = "$([char]0x256D)$([char]0x2500)"
    $boxBottom = "$([char]0x2570)$([char]0x2500)"
    $arrowSym = "$([char]0x276F)"

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $adminBadge = if ($isAdmin) { "$($c.Err)[ADMIN]$($c.Reset) " } else { "" }

    $timeStr = "$($c.Time)[$(Get-Date -Format 'HH:mm:ss')]$($c.Reset)"
    $statusInd = if ($lastSuccess) { "$($c.Success)➜$($c.Reset)" } else { "$($c.Err)✘$($c.Reset)" }
    $dirStr = "$($c.Dir)$(Format-ZenithPath)$($c.Reset)"
    $gitStr = Get-ZenithGitBranch

    "`n$($c.Frame)$boxTop$($c.Reset) $adminBadge$dirStr$gitStr $timeStr`n$($c.Frame)$boxBottom$($c.Reset)$statusInd $($c.Arrow)$arrowSym$($c.Reset) "
}

# CLI Helper inside PowerShell: zenith <command>
function global:zenith {
    param(
        [Parameter(Position=0)]
        [string]$Command = "help",
        [Parameter(Position=1)]
        [string]$Argument
    )

    $themes = @("cyberpunk", "tokyonight", "catppuccin", "nord", "matrix", "dracula", "minimal")

    switch ($Command.ToLower()) {
        "fetch" {
            if (Get-Command Show-ZenithFetch -ErrorAction SilentlyContinue) {
                Show-ZenithFetch
            } else {
                $f = "C:\Users\Administrator\Documents\zenith-shell\core\fetch.ps1"
                if (Test-Path $f) { . $f; Show-ZenithFetch } else { Write-Host "Fetching specs..." }
            }
        }
        "list" {
            Write-Host "`n🎨 Available Zenith Themes:" -ForegroundColor Cyan
            $current = Get-ZenithActiveTheme
            foreach ($t in $themes) {
                $c = Get-ZenithColors $t
                $activeMark = if ($t -eq $current) { " (active)" } else { "" }
                Write-Host "  • $t$activeMark" -ForegroundColor $(if ($t -eq $current) { [ConsoleColor]::Green } else { [ConsoleColor]::Gray })
            }
            Write-Host "`nUsage: zenith set <theme-name>`n"
        }
        "set" {
            if (-not $Argument) {
                Write-Host "❌ Error: Please specify a theme name. Example: zenith set tokyonight" -ForegroundColor Red
                return
            }
            if ($themes -contains $Argument.ToLower()) {
                if (-not (Test-Path $script:ZenithDir)) { New-Item -ItemType Directory -Force -Path $script:ZenithDir | Out-Null }
                Set-Content -Path $script:ZenithThemeFile -Value $Argument.ToLower()
                Write-Host "✨ Zenith theme switched to: $Argument" -ForegroundColor Green
            } else {
                Write-Host "❌ Unknown theme: $Argument. Run 'zenith list' to see all themes." -ForegroundColor Red
            }
        }
        "preview" {
            Write-Host "`n🌟 Zenith Themes Preview:`n" -ForegroundColor Yellow
            $boxTop = "$([char]0x256D)$([char]0x2500)"
            $boxBottom = "$([char]0x2570)$([char]0x2500)"
            $arrowSym = "$([char]0x276F)"
            $gitIcon = "$([char]0x2387)"

            foreach ($t in $themes) {
                $c = Get-ZenithColors $t
                Write-Host "[$t]" -ForegroundColor White
                Write-Host "  $($c.Frame)$boxTop$($c.Reset) $($c.Dir)~/projects/app$($c.Reset) $($c.Git)$gitIcon main$($c.Reset) $($c.Time)[12:00:00]$($c.Reset)"
                Write-Host "  $($c.Frame)$boxBottom$($c.Reset)$($c.Success)➜$($c.Reset) $($c.Arrow)$arrowSym$($c.Reset) ls`n"
            }
        }
        "info" {
            Write-Host "`n⚡ Zenith Shell Prompt Engine" -ForegroundColor Cyan
            Write-Host "  Active Theme : $(Get-ZenithActiveTheme)" -ForegroundColor White
            Write-Host "  Shell        : PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor White
            Write-Host "  Config Path  : $script:ZenithThemeFile`n" -ForegroundColor White
        }
        Default {
            Write-Host "`n⚡ Zenith Shell CLI" -ForegroundColor Cyan
            Write-Host "  zenith fetch           - Display full device & hardware specs"
            Write-Host "  zenith list            - List all available themes"
            Write-Host "  zenith set <theme>     - Switch the active theme"
            Write-Host "  zenith preview         - Preview all themes visually"
            Write-Host "  zenith info            - Display environment & current theme info`n"
        }
    }
}

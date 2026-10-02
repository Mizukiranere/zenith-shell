# ==============================================================================
# Zenith Shell - Universal Prompt Engine for Windows PowerShell
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

$script:ZenithDir = "$HOME\.zenith"
$script:ZenithThemeFile = "$script:ZenithDir\current_theme"

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
                Env = "$e[38;5;141m"; User = "$e[38;5;111m"; Dir = "$e[38;5;117m"
                Git = "$e[38;5;215m"; GitDirty = "$e[38;5;203m"
                Success = "$e[38;5;120m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;141m"; Reset = "$e[0m"
            }
        }
        "catppuccin" {
            return @{
                Env = "$e[38;5;183m"; User = "$e[38;5;217m"; Dir = "$e[38;5;153m"
                Git = "$e[38;5;223m"; GitDirty = "$e[38;5;210m"
                Success = "$e[38;5;150m"; Err = "$e[38;5;203m"; Arrow = "$e[38;5;183m"; Reset = "$e[0m"
            }
        }
        "nord" {
            return @{
                Env = "$e[38;5;110m"; User = "$e[38;5;109m"; Dir = "$e[38;5;152m"
                Git = "$e[38;5;179m"; GitDirty = "$e[38;5;131m"
                Success = "$e[38;5;108m"; Err = "$e[38;5;131m"; Arrow = "$e[38;5;110m"; Reset = "$e[0m"
            }
        }
        "matrix" {
            return @{
                Env = "$e[38;5;46m"; User = "$e[38;5;34m"; Dir = "$e[38;5;82m"
                Git = "$e[38;5;118m"; GitDirty = "$e[38;5;196m"
                Success = "$e[38;5;46m"; Err = "$e[38;5;160m"; Arrow = "$e[38;5;46m"; Reset = "$e[0m"
            }
        }
        "dracula" {
            return @{
                Env = "$e[38;5;141m"; User = "$e[38;5;212m"; Dir = "$e[38;5;117m"
                Git = "$e[38;5;228m"; GitDirty = "$e[38;5;203m"
                Success = "$e[38;5;84m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;212m"; Reset = "$e[0m"
            }
        }
        "minimal" {
            return @{
                Env = "$e[38;5;244m"; User = "$e[38;5;250m"; Dir = "$e[38;5;255m"
                Git = "$e[38;5;248m"; GitDirty = "$e[38;5;203m"
                Success = "$e[38;5;255m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;250m"; Reset = "$e[0m"
            }
        }
        Default { # Cyberpunk
            return @{
                Env = "$e[38;5;51m"; User = "$e[38;5;198m"; Dir = "$e[38;5;226m"
                Git = "$e[38;5;201m"; GitDirty = "$e[38;5;196m"
                Success = "$e[38;5;48m"; Err = "$e[38;5;196m"; Arrow = "$e[38;5;51m"; Reset = "$e[0m"
            }
        }
    }
}

function Get-ZenithGitBranch {
    $c = Get-ZenithColors (Get-ZenithActiveTheme)
    try {
        $b = (& git symbolic-ref --short HEAD 2>$null)
        if (-not $b) {
            $b = (& git describe --tags --always 2>$null)
        }
        if ($b) {
            $status = (& git status --porcelain 2>$null)
            $dirty = if ($status) { "$($c.GitDirty)*" } else { "" }
            return " $($c.Git) $b$dirty$($c.Reset)"
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

# Override Global PowerShell Prompt
function global:prompt {
    $lastSuccess = $?
    $theme = Get-ZenithActiveTheme
    $c = Get-ZenithColors $theme

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $adminBadge = if ($isAdmin) { "$($c.Err)[ADMIN]$($c.Reset) " } else { "" }

    $statusInd = if ($lastSuccess) { "$($c.Success)➜$($c.Reset)" } else { "$($c.Err)✘$($c.Reset)" }
    $dirStr = "$($c.Dir)$(Format-ZenithPath)$($c.Reset)"
    $gitStr = Get-ZenithGitBranch

    "`n$adminBadge$dirStr$gitStr`n$statusInd $($c.Arrow)❯$($c.Reset) "
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
            foreach ($t in $themes) {
                $c = Get-ZenithColors $t
                Write-Host "[$t]" -ForegroundColor White
                Write-Host "  $($c.Dir)~/projects/app$($c.Reset) $($c.Git) main$($c.Reset)"
                Write-Host "  $($c.Success)➜$($c.Reset) $($c.Arrow)❯$($c.Reset) ls`n"
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
            Write-Host "  zenith list            - List all available themes"
            Write-Host "  zenith set <theme>     - Switch the active theme"
            Write-Host "  zenith preview         - Preview all themes visually"
            Write-Host "  zenith info            - Display environment & current theme info`n"
        }
    }
}

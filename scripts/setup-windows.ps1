# Dotfiles bootstrap for native Windows host configuration.
#
# Modes:
#   fresh   - install Windows-side apps, then apply configs
#   update  - install/check missing apps, then apply configs
#   link    - only apply configs
#   doctor  - verify app commands and config paths
#
# Examples:
#   .\scripts\setup-windows.ps1 fresh -Yes
#   .\scripts\setup-windows.ps1 update -Yes
#   .\scripts\setup-windows.ps1 link -DryRun
#   .\scripts\setup-windows.ps1 doctor

[CmdletBinding()]
param(
    [ValidateSet("fresh", "update", "link", "doctor")]
    [string]$Mode = "update",

    [switch]$Yes,
    [switch]$DryRun,
    [switch]$NoInstall,
    [switch]$NoLink,

    # Default: fresh installs GUI apps; update does not unless -Gui is supplied.
    [switch]$Gui,
    [switch]$NoGui,

    # Default: fresh installs Sioyek; update does not unless -Latex is supplied.
    [switch]$Latex,
    [switch]$NoLatex,

    # Default is copy-with-backup. Use -UseSymlinks only if Developer Mode/admin symlink
    # permissions are working and you want live links.
    [switch]$UseSymlinks
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$InstallGui = $false
$InstallLatex = $false

if ($Mode -eq "fresh") {
    $InstallGui = $true
    $InstallLatex = $true
}
if ($Gui) { $InstallGui = $true }
if ($NoGui) { $InstallGui = $false }
if ($Latex) { $InstallLatex = $true }
if ($NoLatex) { $InstallLatex = $false }

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "WARN: $Message" -ForegroundColor Yellow
}

function Invoke-Logged {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Command
    )

    if ($DryRun) {
        Write-Host "[dry-run] $($Command -join ' ')"
    } else {
        & $Command[0] @($Command | Select-Object -Skip 1)
    }
}

function Confirm-Action {
    param([string]$Prompt)

    if ($Yes -or $DryRun) { return $true }

    $reply = Read-Host "$Prompt [y/N]"
    return $reply -match "^[Yy]$"
}

function Ensure-Dir {
    param([string]$Path)

    if ($DryRun) {
        Write-Host "[dry-run] mkdir $Path"
        return
    }

    New-Item -ItemType Directory -Force $Path | Out-Null
}

function Backup-Path {
    param([string]$Path)

    if (Test-Path $Path) {
        $Backup = "$Path.backup.$Timestamp"
        Write-Step "Backing up $Path -> $Backup"
        if (-not $DryRun) {
            Move-Item $Path $Backup -Force
        }
    }
}

function Apply-Path {
    param(
        [string]$Source,
        [string]$Destination,
        [ValidateSet("File", "Directory")]
        [string]$Kind
    )

    if (-not (Test-Path $Source)) {
        Write-Warn "Missing source, skipping: $Source"
        return
    }

    $Parent = Split-Path -Parent $Destination
    Ensure-Dir $Parent

    if (Test-Path $Destination) {
        if (-not (Confirm-Action "Replace existing $Destination?")) {
            Write-Warn "Skipped existing path: $Destination"
            return
        }
        Backup-Path $Destination
    }

    if ($UseSymlinks) {
        Write-Step "Linking $Destination -> $Source"
        if (-not $DryRun) {
            if ($Kind -eq "Directory") {
                New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
            } else {
                New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
            }
        }
    } else {
        Write-Step "Copying $Source -> $Destination"
        if (-not $DryRun) {
            if ($Kind -eq "Directory") {
                Ensure-Dir $Destination
                Copy-Item (Join-Path $Source "*") $Destination -Recurse -Force
            } else {
                Copy-Item $Source $Destination -Force
            }
        }
    }
}

function Get-WindowsTerminalSettingsPath {
    $Candidates = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
    )

    foreach ($Candidate in $Candidates) {
        if (Test-Path $Candidate) { return $Candidate }
    }

    return $Candidates[0]
}

function Test-CommandExists {
    param([string]$Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
    param(
        [string]$Id,
        [string]$Label = $Id
    )

    if (-not (Test-CommandExists "winget")) {
        Write-Warn "winget is missing; cannot install $Label"
        return
    }

    Write-Step "Installing/checking $Label via winget: $Id"

    if ($DryRun) {
        Write-Host "[dry-run] winget install --id $Id --exact --silent --accept-source-agreements --accept-package-agreements"
        return
    }

    winget install --id $Id --exact --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warn "winget install failed or package id is unavailable: $Id"
    }
}

function Install-Packages {
    if ($NoInstall -or $Mode -eq "link" -or $Mode -eq "doctor") { return }

    Write-Step "Mode: $Mode"
    Write-Step "Install GUI apps: $InstallGui"
    Write-Step "Install Sioyek/LaTeX viewer: $InstallLatex"

    if (-not (Confirm-Action "Proceed with Windows package installation?")) {
        Write-Warn "Skipped package installation."
        return
    }

    Install-WingetPackage "Git.Git" "Git"
    Install-WingetPackage "Microsoft.WindowsTerminal" "Windows Terminal"

    if ($InstallGui) {
        # If any ID changes, the script warns and continues.
        Install-WingetPackage "glzr-io.glazewm" "GlazeWM"
        Install-WingetPackage "glzr-io.zebar" "Zebar"
        Install-WingetPackage "Alacritty.Alacritty" "Alacritty"
        Install-WingetPackage "Neovide.Neovide" "Neovide"
    }

    if ($InstallLatex) {
        Install-WingetPackage "ahrm.sioyek" "Sioyek"
    }

    Write-Warn "Font installation is intentionally not forced. Install a Nerd Font manually if terminal icons look wrong."
}

function Apply-Configs {
    if ($NoLink -or $Mode -eq "doctor") { return }

    Write-Step "Applying Windows configs"
    if ($UseSymlinks) {
        Write-Warn "Using symlinks. If this fails, enable Windows Developer Mode or run PowerShell as Administrator."
    } else {
        Write-Warn "Using copy-with-backup by default for Windows app configs."
    }

    Apply-Path `
        -Source "$RepoRoot\windows\glazewm\config.yaml" `
        -Destination "$env:USERPROFILE\.glzr\glazewm\config.yaml" `
        -Kind File

    Apply-Path `
        -Source "$RepoRoot\windows\zebar" `
        -Destination "$env:USERPROFILE\.glzr\zebar" `
        -Kind Directory

    $WtSettings = Get-WindowsTerminalSettingsPath
    Apply-Path `
        -Source "$RepoRoot\windows\windows-terminal\settings.json" `
        -Destination $WtSettings `
        -Kind File

    Apply-Path `
        -Source "$RepoRoot\windows\powershell\Microsoft.PowerShell_profile.ps1" `
        -Destination $PROFILE `
        -Kind File

    Ensure-SioyekPrefs
}

function Ensure-SioyekPrefs {
    $SioyekDir = Join-Path $env:APPDATA "sioyek"
    $Prefs = Join-Path $SioyekDir "prefs_user.config"

    Ensure-Dir $SioyekDir

    if ($DryRun) {
        Write-Host "[dry-run] ensure $Prefs contains vimtex_wsl_fix 1"
        return
    }

    if (-not (Test-Path $Prefs)) {
        New-Item -ItemType File -Path $Prefs -Force | Out-Null
    }

    $Content = Get-Content $Prefs -Raw -ErrorAction SilentlyContinue
    if ($Content -notmatch "(?m)^vimtex_wsl_fix\s+1\s*$") {
        Add-Content $Prefs "`nvimtex_wsl_fix 1"
        Write-Step "Added vimtex_wsl_fix 1 to $Prefs"
    }
}

function Check-Path {
    param([string]$Label, [string]$Path)

    if (Test-Path $Path) {
        Write-Host ("  [ok]   {0,-28} {1}" -f $Label, $Path)
    } else {
        Write-Host ("  [miss] {0,-28} {1}" -f $Label, $Path)
    }
}

function Check-Command {
    param([string]$Command)

    $Found = Get-Command $Command -ErrorAction SilentlyContinue
    if ($null -ne $Found) {
        Write-Host ("  [ok]   {0,-18} {1}" -f $Command, $Found.Source)
    } else {
        Write-Host ("  [miss] {0,-18}" -f $Command)
    }
}

function Invoke-Doctor {
    Write-Step "Windows dotfiles doctor"
    Write-Host "Repo root: $RepoRoot"
    Write-Host ""

    Write-Host "Commands:"
    foreach ($Command in @("winget", "git", "wt", "sioyek", "glazewm", "zebar", "wsl")) {
        Check-Command $Command
    }

    Write-Host ""
    Write-Host "Config paths:"
    Check-Path "GlazeWM config" "$env:USERPROFILE\.glzr\glazewm\config.yaml"
    Check-Path "Zebar config dir" "$env:USERPROFILE\.glzr\zebar"
    Check-Path "Windows Terminal" (Get-WindowsTerminalSettingsPath)
    Check-Path "PowerShell profile" $PROFILE
    Check-Path "Sioyek prefs" (Join-Path $env:APPDATA "sioyek\prefs_user.config")

    Write-Host ""
    Write-Host "WSL:"
    if (Test-CommandExists "wsl") {
        wsl -l -v
    }
}

Install-Packages
Apply-Configs
Invoke-Doctor

Write-Step "Done"

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot

function Ensure-Dir {
    param([string]$Path)
    New-Item -ItemType Directory -Force $Path | Out-Null
}

function Copy-FileIfExists {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (Test-Path $Source) {
        Ensure-Dir (Split-Path -Parent $Destination)
        Copy-Item $Source $Destination -Force
        Write-Host "Imported file: $Source -> $Destination"
    } else {
        Write-Host "Skipped missing file: $Source"
    }
}

function Copy-DirIfExists {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (Test-Path $Source) {
        Ensure-Dir $Destination
        Copy-Item "$Source\*" $Destination -Recurse -Force
        Write-Host "Imported directory: $Source -> $Destination"
    } else {
        Write-Host "Skipped missing directory: $Source"
    }
}

function Get-WindowsTerminalSettingsPath {
    $candidates = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) { return $candidate }
    }

    return $null
}

Write-Host "Repo root: $RepoRoot"
Write-Host "Importing live Windows configs into repo..."
Write-Host ""

Copy-FileIfExists `
    "$env:USERPROFILE\.glzr\glazewm\config.yaml" `
    "$RepoRoot\windows\glazewm\config.yaml"

Copy-DirIfExists `
    "$env:USERPROFILE\.glzr\zebar" `
    "$RepoRoot\windows\zebar"

$wtSettings = Get-WindowsTerminalSettingsPath
if ($null -ne $wtSettings) {
    Copy-FileIfExists $wtSettings "$RepoRoot\windows\windows-terminal\settings.json"
} else {
    Write-Host "Skipped Windows Terminal: settings.json not found."
}

if (Test-Path $PROFILE) {
    Copy-FileIfExists $PROFILE "$RepoRoot\windows\powershell\Microsoft.PowerShell_profile.ps1"
} else {
    Ensure-Dir "$RepoRoot\windows\powershell"
    @'
# Native Windows PowerShell profile.
# Keep this minimal. Main dev shell is WSL/Zsh.

# Put Windows-only aliases/functions here.
'@ | Set-Content "$RepoRoot\windows\powershell\Microsoft.PowerShell_profile.ps1"
    Write-Host "Created minimal PowerShell profile in repo."
}

Write-Host ""
Write-Host "Import complete. Check with: git status --short"

$ErrorActionPreference = "Stop"

param(
    [switch]$DryRun
)

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Ensure-Dir {
    param([string]$Path)
    New-Item -ItemType Directory -Force $Path | Out-Null
}

function Copy-FileWithBackup {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Source)) {
        Write-Host "Skipped missing source file: $Source"
        return
    }

    Ensure-Dir (Split-Path -Parent $Destination)

    if ($DryRun) {
        Write-Host "[dry-run] file: $Source -> $Destination"
        return
    }

    if (Test-Path $Destination) {
        Copy-Item $Destination "$Destination.backup.$Timestamp" -Force
        Write-Host "Backed up: $Destination"
    }

    Copy-Item $Source $Destination -Force
    Write-Host "Applied file: $Source -> $Destination"
}

function Copy-DirWithBackup {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Source)) {
        Write-Host "Skipped missing source directory: $Source"
        return
    }

    if ($DryRun) {
        Write-Host "[dry-run] directory: $Source -> $Destination"
        return
    }

    if (Test-Path $Destination) {
        $backup = "$Destination.backup.$Timestamp"
        Copy-Item $Destination $backup -Recurse -Force
        Write-Host "Backed up directory: $Destination"
    }

    Ensure-Dir $Destination
    Copy-Item "$Source\*" $Destination -Recurse -Force
    Write-Host "Applied directory: $Source -> $Destination"
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

    # Default to the packaged stable path if the file does not exist yet.
    return $candidates[0]
}

Write-Host "Repo root: $RepoRoot"
Write-Host "Applying repo Windows configs to live Windows paths..."
Write-Host ""

Copy-FileWithBackup `
    "$RepoRoot\windows\glazewm\config.yaml" `
    "$env:USERPROFILE\.glzr\glazewm\config.yaml"

Copy-DirWithBackup `
    "$RepoRoot\windows\zebar" `
    "$env:USERPROFILE\.glzr\zebar"

$wtSettings = Get-WindowsTerminalSettingsPath
Copy-FileWithBackup `
    "$RepoRoot\windows\windows-terminal\settings.json" `
    $wtSettings

Copy-FileWithBackup `
    "$RepoRoot\windows\powershell\Microsoft.PowerShell_profile.ps1" `
    $PROFILE

Write-Host ""
Write-Host "Windows configs applied. Restart Windows Terminal and reload GlazeWM/Zebar."

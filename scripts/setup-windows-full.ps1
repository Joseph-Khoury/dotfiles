<#
.SYNOPSIS
    Full Windows + WSL bootstrap for this dotfiles repository.

.DESCRIPTION
    This script is intended to live at:

        <repo>\scripts\setup-windows-full.ps1

    It provisions the Windows host side and the WSL Debian side of the dotfiles
    setup without modifying the older/legacy scripts in the repository.

    It is designed around this architecture:

        Windows host
          - GlazeWM + Zebar
          - Windows Terminal settings
          - Neovide configured for WSL Neovim
          - AutoHotkey v2 wrapper for opening files in Neovide WSL
          - Sioyek for VimTeX PDF viewing
          - user-level file associations for code/text/LaTeX files

        WSL Debian
          - ~/.dotfiles -> /mnt/c/Users/<WindowsUser>/.dotfiles
          - zsh + tmux + Neovim + shell plugins
          - apt base packages
          - Linuxbrew for newer CLI tools
          - official Neovim tarball installed at /opt/nvim-linux-x86_64
          - WSL wrapper for Sioyek/VimTeX inverse search

    The script deliberately does not call or edit these older scripts:

        scripts/apply-windows.ps1
        scripts/apply-wsl.sh
        scripts/install-wsl-tools.sh
        scripts/setup-windows.ps1

    Existing real files/directories are backed up before being replaced by
    symlinks. Existing correct symlinks are left alone. The script does not
    generate replacement config files inside the dotfiles repository.

.EXAMPLES
    # Recommended first run from an elevated PowerShell:
    .\scripts\setup-windows-full.ps1 fresh -Yes

    # Re-apply symlinks only:
    .\scripts\setup-windows-full.ps1 link -Yes

    # Check current machine state:
    .\scripts\setup-windows-full.ps1 doctor

    # Preview actions:
    .\scripts\setup-windows-full.ps1 fresh -DryRun
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet("fresh", "update", "link", "doctor")]
    [string]$Mode = "fresh",

    # Defaults to the parent of this script's directory, assuming this file lives in <repo>\scripts.
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),

    [string]$DistroName = "Debian",

    [switch]$Yes,
    [switch]$DryRun,

    [switch]$NoInstall,
    [switch]$NoWSL,
    [switch]$NoLinks,
    [switch]$NoFileAssociations,
    [switch]$NoLatex,
    [switch]$NoLinuxbrew,
    [switch]$NoOfficialNeovim,
    [switch]$NoLazySync,
    [switch]$NoAdminRelaunch,

    # File associations are attempted per-user. On modern Windows, an existing
    # UserChoice hash can prevent direct replacement for already-claimed extensions.
    [switch]$PreserveExistingAssociationDefaults
)

$ErrorActionPreference = "Stop"
$script:Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# -----------------------------------------------------------------------------
# Logging / helpers
# -----------------------------------------------------------------------------

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "WARN: $Message" -ForegroundColor Yellow
}

function Write-Ok {
    param([string]$Message)
    Write-Host "OK: $Message" -ForegroundColor Green
}

function Quote-Argument {
    param([string]$Value)
    if ($null -eq $Value) { return '""' }
    if ($Value -match '[\s"]') {
        return '"' + ($Value -replace '"', '\"') + '"'
    }
    return $Value
}

function Confirm-Action {
    param([string]$Prompt)
    if ($Yes -or $DryRun) { return $true }
    $reply = Read-Host "$Prompt [y/N]"
    return $reply -match '^[Yy]$'
}

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Relaunch-AsAdminIfNeeded {
    if ($DryRun) { return }
    if (Test-IsAdmin) { return }

    if ($NoAdminRelaunch) {
        throw "This script should be run as Administrator. Re-run from an elevated PowerShell."
    }

    if (-not $PSCommandPath) {
        throw "Cannot auto-relaunch as admin because PSCommandPath is unavailable. Re-run from an elevated PowerShell."
    }

    Write-Warn "Not running as Administrator. Relaunching elevated..."

    $currentExe = (Get-Process -Id $PID).Path
    if (-not $currentExe) { $currentExe = "powershell.exe" }

    $args = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $PSCommandPath,
        "-Mode", $Mode,
        "-RepoRoot", $RepoRoot,
        "-DistroName", $DistroName
    )

    foreach ($item in @(
        @{ Name = "Yes"; Value = $Yes },
        @{ Name = "NoInstall"; Value = $NoInstall },
        @{ Name = "NoWSL"; Value = $NoWSL },
        @{ Name = "NoLinks"; Value = $NoLinks },
        @{ Name = "NoFileAssociations"; Value = $NoFileAssociations },
        @{ Name = "NoLatex"; Value = $NoLatex },
        @{ Name = "NoLinuxbrew"; Value = $NoLinuxbrew },
        @{ Name = "NoOfficialNeovim"; Value = $NoOfficialNeovim },
        @{ Name = "NoLazySync"; Value = $NoLazySync },
        @{ Name = "PreserveExistingAssociationDefaults"; Value = $PreserveExistingAssociationDefaults }
    )) {
        if ($item.Value) { $args += "-$($item.Name)" }
    }

    $argString = ($args | ForEach-Object { Quote-Argument $_ }) -join " "
    Start-Process -FilePath $currentExe -ArgumentList $argString -Verb RunAs | Out-Null
    exit 0
}

function Ensure-Dir {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    if ($DryRun) {
        Write-Host "[dry-run] mkdir $Path"
        return
    }
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )
    if ($DryRun) {
        Write-Host "[dry-run] write $Path"
        return
    }
    Ensure-Dir (Split-Path -Parent $Path)
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Test-CommandExists {
    param([string]$Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Invoke-Native {
    param(
        [Parameter(Mandatory = $true)]
        [string]$File,

        [string[]]$Arguments = @(),

        [switch]$ContinueOnError
    )

    $display = @($File) + $Arguments
    if ($DryRun) {
        Write-Host ("[dry-run] " + (($display | ForEach-Object { Quote-Argument $_ }) -join " "))
        return $true
    }

    & $File @Arguments
    $code = $LASTEXITCODE
    if ($code -ne 0 -and -not $ContinueOnError) {
        throw "Command failed with exit code ${code}: $($display -join ' ')"
    }
    return ($code -eq 0)
}

function Resolve-RepoRoot {
    $resolved = [System.IO.Path]::GetFullPath($RepoRoot)
    $required = @(
        "windows\glazewm\config.yaml",
        "windows\zebar\settings.json",
        "windows\windows-terminal\settings.json",
        "windows\Neovide-wsl\config.toml",
        "common\nvim\init.lua",
        "common\shell\zsh\zshrc",
        "common\tmux\tmux.conf"
    )

    foreach ($rel in $required) {
        $path = Join-Path $resolved $rel
        if (-not (Test-Path $path)) {
            throw "Repo root does not look correct. Missing: $path`nPass -RepoRoot C:\Users\<you>\.dotfiles if running this script from elsewhere."
        }
    }

    $script:RepoRoot = $resolved.TrimEnd('\')
    Write-Step "Repo root: $script:RepoRoot"

    $preferred = Join-Path $env:USERPROFILE ".dotfiles"
    if ($script:RepoRoot -ne $preferred) {
        Write-Warn "Preferred Windows repo path is $preferred. Current path is $script:RepoRoot. WSL symlinks will still be generated for the current path."
    }
}

# -----------------------------------------------------------------------------
# Symlink handling
# -----------------------------------------------------------------------------

function Get-LinkTargetString {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    $item = Get-Item $Path -Force
    if (-not $item.Attributes.HasFlag([IO.FileAttributes]::ReparsePoint)) { return $null }
    $target = $item.Target
    if ($target -is [array]) { return ($target -join ";") }
    return [string]$target
}

function Test-SameLink {
    param(
        [string]$Destination,
        [string]$Source
    )

    if (-not (Test-Path $Destination)) { return $false }
    $target = Get-LinkTargetString $Destination
    if (-not $target) { return $false }

    try {
        $targetFull = [System.IO.Path]::GetFullPath($target).TrimEnd('\')
        $sourceFull = [System.IO.Path]::GetFullPath($Source).TrimEnd('\')
        return ($targetFull -ieq $sourceFull)
    } catch {
        return ($target -ieq $Source)
    }
}

function Backup-Path {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }

    $backup = "$Path.backup.$script:Timestamp"
    Write-Step "Backing up $Path -> $backup"
    if (-not $DryRun) {
        Move-Item -LiteralPath $Path -Destination $backup -Force
    }
}

function New-SafeSymlink {
    param(
        [Parameter(Mandatory = $true)] [string]$Source,
        [Parameter(Mandatory = $true)] [string]$Destination,
        [ValidateSet("File", "Directory")] [string]$Kind
    )

    if (-not (Test-Path $Source)) {
        Write-Warn "Missing source, skipping: $Source"
        return
    }

    Ensure-Dir (Split-Path -Parent $Destination)

    if (Test-SameLink -Destination $Destination -Source $Source) {
        Write-Ok "Already linked: $Destination -> $Source"
        return
    }

    if (Test-Path $Destination) {
        if (-not (Confirm-Action "Replace existing $Destination with symlink to $Source?")) {
            Write-Warn "Skipped existing path: $Destination"
            return
        }
        Backup-Path $Destination
    }

    Write-Step "Linking $Destination -> $Source"
    if (-not $DryRun) {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -Force | Out-Null
    }
}

function Test-SymlinkCapability {
    if ($DryRun) { return }

    $dir = Join-Path $env:TEMP "dotfiles-symlink-test-$([Guid]::NewGuid().ToString('N'))"
    $src = Join-Path $dir "source.txt"
    $dst = Join-Path $dir "link.txt"

    try {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Set-Content -Path $src -Value "ok"
        New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
        Remove-Item -Path $dir -Recurse -Force
    } catch {
        throw "Windows symlink creation failed. Run as Administrator or enable Developer Mode. Original error: $($_.Exception.Message)"
    }
}

# -----------------------------------------------------------------------------
# Windows package installation
# -----------------------------------------------------------------------------

function Install-WingetPackageCandidates {
    param(
        [string]$Label,
        [string[]]$Ids
    )

    if (-not (Test-CommandExists "winget")) {
        Write-Warn "winget is missing; cannot install $Label. Install App Installer / winget, then rerun."
        return
    }

    foreach ($id in $Ids) {
        Write-Step "Installing/checking $Label via winget: $id"
        $ok = Invoke-Native -File "winget" -Arguments @(
            "install", "--id", $id, "--exact",
            "--silent",
            "--accept-source-agreements",
            "--accept-package-agreements",
            "--disable-interactivity"
        ) -ContinueOnError

        if ($ok) {
            Write-Ok "$Label installed or already present: $id"
            return
        }

        Write-Warn "winget candidate failed for ${Label}: $id"
    }

    Write-Warn "Could not install $Label automatically. Install it manually, then rerun doctor."
}

function Install-WindowsPackages {
    if ($NoInstall -or $Mode -in @("link", "doctor")) { return }

    Write-Step "Installing requested Windows host packages"
    if (-not (Confirm-Action "Proceed with winget installs for AutoHotkey v2, Sioyek, Neovide, GlazeWM, Zebar, and JetBrainsMono Nerd Font?")) {
        Write-Warn "Skipped Windows package installation."
        return
    }

    Install-WingetPackageCandidates -Label "AutoHotkey v2" -Ids @(
        "AutoHotkey.AutoHotkey",
        "Lexikos.AutoHotkey"
    )

    Install-WingetPackageCandidates -Label "Sioyek" -Ids @(
        "ahrm.sioyek"
    )

    Install-WingetPackageCandidates -Label "Neovide" -Ids @(
        "Neovide.Neovide"
    )

    Install-WingetPackageCandidates -Label "GlazeWM" -Ids @(
        "glzr-io.glazewm",
        "GlazeWM.GlazeWM"
    )

    Install-WingetPackageCandidates -Label "Zebar" -Ids @(
        "glzr-io.zebar"
    )

    Install-WingetPackageCandidates -Label "JetBrainsMono Nerd Font" -Ids @(
        "DEVCOM.JetBrainsMonoNerdFont",
        "NerdFonts.JetBrainsMono"
    )

    if (-not (Test-CommandExists "wt")) {
        Write-Warn "Windows Terminal command 'wt' was not found. Your Windows Terminal settings will still be linked if the settings path exists."
    }
}

# -----------------------------------------------------------------------------
# Windows config linking
# -----------------------------------------------------------------------------

function Get-WindowsTerminalSettingsPath {
    $candidates = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) { return $candidate }
    }

    return $candidates[0]
}

function Get-GlazeWmConfigSource {
    # The live GlazeWM config should point directly at the tracked dotfiles file.
    # Do not generate a replacement config here; live GlazeWM config stays tracked.
    return (Join-Path $script:RepoRoot "windows\glazewm\config.yaml")
}

function Apply-WindowsConfigs {
    if ($NoLinks -or $Mode -eq "doctor") { return }

    Write-Step "Applying Windows config symlinks"
    Test-SymlinkCapability

    New-SafeSymlink `
        -Source (Get-GlazeWmConfigSource) `
        -Destination (Join-Path $env:USERPROFILE ".glzr\glazewm\config.yaml") `
        -Kind File

    New-SafeSymlink `
        -Source (Join-Path $script:RepoRoot "windows\zebar") `
        -Destination (Join-Path $env:USERPROFILE ".glzr\zebar") `
        -Kind Directory

    New-SafeSymlink `
        -Source (Join-Path $script:RepoRoot "windows\windows-terminal\settings.json") `
        -Destination (Get-WindowsTerminalSettingsPath) `
        -Kind File

    New-SafeSymlink `
        -Source (Join-Path $script:RepoRoot "windows\powershell\Microsoft.PowerShell_profile.ps1") `
        -Destination $PROFILE `
        -Kind File

    New-SafeSymlink `
        -Source (Join-Path $script:RepoRoot "windows\Neovide-wsl\config.toml") `
        -Destination (Join-Path $env:APPDATA "neovide\config.toml") `
        -Kind File

    Ensure-SioyekPrefs
    Install-NeovideWslLauncher
}

function Ensure-SioyekPrefs {
    $sioyekDir = Join-Path $env:APPDATA "sioyek"
    $prefs = Join-Path $sioyekDir "prefs_user.config"

    Ensure-Dir $sioyekDir

    if ($DryRun) {
        Write-Host "[dry-run] ensure $prefs contains: vimtex_wsl_fix 1"
        return
    }

    if (-not (Test-Path $prefs)) {
        New-Item -ItemType File -Path $prefs -Force | Out-Null
    }

    $content = Get-Content $prefs -Raw -ErrorAction SilentlyContinue
    if ($content -notmatch '(?m)^vimtex_wsl_fix\s+1\s*$') {
        Add-Content -Path $prefs -Value "`nvimtex_wsl_fix 1"
        Write-Ok "Added vimtex_wsl_fix 1 to $prefs"
    } else {
        Write-Ok "Sioyek VimTeX WSL fix already present"
    }
}

function Install-NeovideWslLauncher {
    $sourceDir = Join-Path $script:RepoRoot "windows\Neovide-wsl"
    $destDir = Join-Path $env:LOCALAPPDATA "Programs\NeovideWSL"

    New-SafeSymlink -Source $sourceDir -Destination $destDir -Kind Directory

    $launcher = Join-Path $destDir "NeovideWSL.exe"
    if (-not $DryRun -and -not (Test-Path $launcher)) {
        Write-Warn "NeovideWSL launcher was not found after linking: $launcher"
    }
}

# -----------------------------------------------------------------------------
# File associations
# -----------------------------------------------------------------------------

function Set-RegistryDefaultValue {
    param(
        [string]$Path,
        [string]$Value
    )

    if ($DryRun) {
        Write-Host "[dry-run] reg default $Path = $Value"
        return
    }

    New-Item -Path $Path -Force | Out-Null
    Set-Item -Path $Path -Value $Value
}

function Register-FileAssociations {
    if ($NoFileAssociations -or $Mode -eq "doctor") { return }

    $launcher = Join-Path $env:LOCALAPPDATA "Programs\NeovideWSL\NeovideWSL.exe"
    $icon = Join-Path $env:LOCALAPPDATA "Programs\NeovideWSL\Neovide.ico"
    $progId = "Dotfiles.NeovideWSLFile"
    $progKey = "HKCU:\Software\Classes\$progId"

    Write-Step "Registering NeovideWSL file opener"

    Set-RegistryDefaultValue -Path $progKey -Value "Neovide WSL File"
    Set-RegistryDefaultValue -Path "$progKey\DefaultIcon" -Value "`"$icon`",0"
    Set-RegistryDefaultValue -Path "$progKey\shell\open\command" -Value "`"$launcher`" `"%1`""

    $extensions = @(
        # text / notes
        ".txt", ".md", ".markdown", ".rst",

        # Python / scripting
        ".py", ".pyw", ".ipynb", ".sh", ".bash", ".zsh", ".ps1", ".psm1", ".psd1",

        # config / data
        ".json", ".jsonc", ".yaml", ".yml", ".toml", ".xml", ".ini", ".cfg", ".conf", ".env", ".gitignore", ".gitattributes",

        # web / general programming
        ".html", ".htm", ".css", ".scss", ".js", ".jsx", ".ts", ".tsx", ".c", ".h", ".cpp", ".hpp", ".cc", ".hh", ".rs", ".go",

        # HDL / FPGA
        ".v", ".vh", ".sv", ".svh", ".vhd", ".vhdl", ".xdc", ".tcl",

        # LaTeX / BibTeX / TeX ecosystem
        ".tex", ".ltx", ".sty", ".cls", ".bib", ".bst", ".bbx", ".cbx", ".dtx", ".ins", ".tikz", ".pgf", ".latexmkrc"
    )

    foreach ($ext in $extensions | Select-Object -Unique) {
        $extKey = "HKCU:\Software\Classes\$ext"

        if ($DryRun) {
            Write-Host "[dry-run] associate $ext -> $progId"
            continue
        }

        New-Item -Path $extKey -Force | Out-Null

        $openWith = Join-Path $extKey "OpenWithProgids"
        New-Item -Path $openWith -Force | Out-Null
        New-ItemProperty -Path $openWith -Name $progId -PropertyType Binary -Value ([byte[]]@()) -Force | Out-Null

        if (-not $PreserveExistingAssociationDefaults) {
            Set-Item -Path $extKey -Value $progId
        }
    }

    Write-Warn "Windows may keep an existing Default Apps 'UserChoice' for extensions already assigned to another app. NeovideWSL should still appear in Open with."
}

# -----------------------------------------------------------------------------
# WSL provisioning
# -----------------------------------------------------------------------------

function Get-WslDistroNames {
    if (-not (Test-CommandExists "wsl.exe")) { return @() }

    # In DryRun mode, do not query WSL. On a fresh Windows machine, wsl.exe may
    # exist even though the WSL feature has not actually been installed yet, and
    # `wsl -l` can emit a NativeCommandError before the script has had a chance
    # to run `wsl --install`. Returning an empty list lets the dry run show the
    # intended install steps without producing scary errors.
    if ($DryRun) { return @() }

    try {
        # Use cmd.exe for stderr redirection because older Windows PowerShell
        # versions can surface native stderr as NativeCommandError even when the
        # caller only wants to probe availability.
        $raw = & cmd.exe /d /c "wsl.exe -l -q 2>NUL"
        $code = $LASTEXITCODE
    } catch {
        return @()
    }

    if ($code -ne 0) { return @() }
    return @($raw | ForEach-Object { ($_ -replace "`0", "").Trim() } | Where-Object { $_ })
}

function Ensure-WSLAndDebian {
    if ($NoWSL -or $NoInstall -or $Mode -in @("link", "doctor")) { return }

    Write-Step "Checking WSL and $DistroName"

    if (-not (Test-CommandExists "wsl.exe")) {
        throw "wsl.exe was not found on PATH. This script expects modern Windows WSL tooling. Install/update Windows Subsystem for Linux, then rerun."
    }

    # Important: wsl.exe can exist even when WSL itself has not been fully
    # installed/provisioned. Always ask Windows to ensure the base WSL
    # components exist; on already-configured machines this is effectively a
    # no-op or returns a harmless non-zero code that we tolerate.
    Write-Step "Ensuring WSL base components"
    $baseOk = Invoke-Native -File "wsl.exe" -Arguments @("--install", "--no-distribution") -ContinueOnError
    if (-not $baseOk) {
        Write-Warn "wsl --install --no-distribution returned a non-zero code. This is often harmless when WSL is already installed."
    }
    Write-Warn "If Windows reports that WSL components were installed or updated, reboot, launch Debian once, then rerun this script."

    $distros = Get-WslDistroNames
    if ($distros -notcontains $DistroName) {
        Write-Step "Installing WSL distro: $DistroName"
        $distroOk = Invoke-Native -File "wsl.exe" -Arguments @("--install", "-d", $DistroName) -ContinueOnError
        if (-not $distroOk) {
            throw "Could not install WSL distro '$DistroName'. Reboot if WSL was just enabled, then rerun this script or run 'wsl --install -d $DistroName' manually."
        }
        Write-Warn "If Debian asks you to create a UNIX user, finish that first, then rerun this script."
    }

    # Refresh the distro list after any attempted install. A first WSL install can
    # return before the distro is actually registered, especially when Windows
    # still needs a reboot or the Store/MSIX distro has not finished initializing.
    $distros = Get-WslDistroNames
    if ($distros -notcontains $DistroName) {
        $seen = if ($distros.Count -gt 0) { ($distros -join ", ") } else { "none" }
        throw "WSL distro '$DistroName' is not registered yet. Registered distros: $seen. Reboot if WSL was just enabled, then run 'wsl --install -d $DistroName' or open Debian once, create the UNIX user if prompted, and rerun this script."
    }

    Invoke-Native -File "wsl.exe" -Arguments @("--set-default", $DistroName) -ContinueOnError | Out-Null

    $ready = Invoke-Native -File "wsl.exe" -Arguments @("-d", $DistroName, "--", "bash", "-lc", "printf ready") -ContinueOnError
    if (-not $ready) {
        throw "WSL distro '$DistroName' is registered but not ready. Run 'wsl -d $DistroName' once, create the UNIX user if prompted, then rerun this script."
    }
}


function ConvertTo-WslPathLocal {
    param([Parameter(Mandatory=$true)][string]$Path)

    $full = [System.IO.Path]::GetFullPath($Path)
    if ($full -match '^([A-Za-z]):[\\/](.*)$') {
        $drive = $Matches[1].ToLowerInvariant()
        $rest = $Matches[2] -replace '\\', '/'
        return "/mnt/$drive/$rest"
    }

    if ($full -match '^\\\\wsl(?:\.localhost)?\\([^\\]+)\\(.*)$') {
        $rest = $Matches[2] -replace '\\', '/'
        return "/$rest"
    }

    throw "Cannot convert path to a WSL /mnt path: $Path"
}

function Invoke-WslProvisioner {
    if ($NoWSL -or $Mode -eq "doctor") { return }

    Write-Step "Provisioning WSL $DistroName"

    $tempDir = Join-Path $env:TEMP "dotfiles-wsl-provision"
    Ensure-Dir $tempDir
    $scriptPath = Join-Path $tempDir "provision-wsl.sh"

    $bash = @'
#!/usr/bin/env bash
set -euo pipefail

WINDOWS_REPO_WIN="${1:?missing Windows repo path}"
WINDOWS_USER="${2:?missing Windows username}"
MODE="${3:-fresh}"
INSTALL_LATEX="${4:-1}"
INSTALL_LINUXBREW="${5:-1}"
INSTALL_OFFICIAL_NVIM="${6:-1}"
RUN_LAZY_SYNC="${7:-1}"

if [[ "$WINDOWS_REPO_WIN" =~ ^/[a-zA-Z0-9_./-] ]]; then
  ROOT="$WINDOWS_REPO_WIN"
else
  ROOT="$(wslpath -u "$WINDOWS_REPO_WIN")"
fi
TS="$(date +%Y%m%d-%H%M%S)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

backup_path() {
  local dest="$1"
  if [[ -e "$dest" || -L "$dest" ]]; then
    mv "$dest" "${dest}.backup.${TS}"
    log "Backed up: $dest"
  fi
}

same_link() {
  local src="$1" dest="$2"
  [[ -L "$dest" ]] || return 1
  [[ "$(readlink "$dest")" == "$src" ]]
}

link_path() {
  local src="$1" dest="$2"
  if [[ ! -e "$src" ]]; then
    warn "Missing source, skipping: $src"
    return 0
  fi
  if same_link "$src" "$dest"; then
    log "Already linked: $dest -> $src"
    return 0
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    backup_path "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  log "Linked: $dest -> $src"
}

apt_install() {
  local packages=("$@")
  if ((${#packages[@]} == 0)); then return 0; fi
  sudo apt-get install -y "${packages[@]}"
}

install_apt_base() {
  log "Installing Debian apt base packages"
  sudo apt-get update

  apt_install \
    zsh git curl ca-certificates openssh-client \
    tmux ripgrep fd-find fzf unzip xz-utils file procps \
    build-essential make gcc g++ pkg-config clang \
    python3 python3-venv python3-pip \
    nodejs npm \
    jq shellcheck shfmt tree

  # Optional tools that may not exist in every Debian release. Linuxbrew covers
  # the important ones later, so failures here are warnings only.
  sudo apt-get install -y fastfetch zoxide atuin eza bat lazygit || true

  mkdir -p "$HOME/.local/bin"
  if have fdfind && ! have fd; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi

  if have batcat && ! have bat; then
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
}

install_latex() {
  [[ "$INSTALL_LATEX" == "1" ]] || return 0
  log "Installing LaTeX packages in WSL"
  apt_install \
    latexmk biber \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-science \
    texlive-pictures
}

install_linuxbrew() {
  [[ "$INSTALL_LINUXBREW" == "1" ]] || return 0

  if [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    log "Installing Linuxbrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log "Linuxbrew already installed"
  fi

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  log "Installing/updating brew CLI tools"
  brew update || true
  brew install lazygit fastfetch zoxide atuin eza bat fd ripgrep fzf jq shellcheck shfmt tree-sitter-cli || true
}

version_ge() {
  local have_version="${1:-}" min_version="${2:-}"
  [[ -n "$have_version" && -n "$min_version" ]] || return 1
  [[ "$have_version" == "$min_version" ]] && return 0
  [[ "$(printf '%s\n%s\n' "$min_version" "$have_version" | sort -V | head -n 1)" == "$min_version" ]]
}

tree_sitter_version() {
  local bin="${1:-tree-sitter}"
  "$bin" --version 2>/dev/null | awk '{print $2}' || true
}

install_tree_sitter_cli() {
  local min_version="0.26.1"
  log "Installing/updating tree-sitter-cli with Linuxbrew only"

  if [[ "$INSTALL_LINUXBREW" != "1" ]]; then
    warn "Linuxbrew was disabled, so tree-sitter-cli will not be installed by this script."
    return 0
  fi

  if [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    warn "Linuxbrew is not available at /home/linuxbrew/.linuxbrew/bin/brew. Skipping tree-sitter-cli."
    return 1
  fi

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  local brew_prefix brew_bin current_version
  brew_prefix="$(brew --prefix)"
  brew_bin="$brew_prefix/bin/tree-sitter"

  if [[ -x "$brew_bin" ]]; then
    current_version="$(tree_sitter_version "$brew_bin")"
  else
    current_version=""
  fi

  if version_ge "$current_version" "$min_version"; then
    log "tree-sitter-cli already satisfies minimum version: $current_version >= $min_version"
  else
    log "Installing/updating tree-sitter-cli from Homebrew"
    brew install tree-sitter-cli || brew upgrade tree-sitter-cli
  fi

  if [[ ! -x "$brew_bin" ]]; then
    brew link --overwrite tree-sitter-cli || true
  fi

  if [[ ! -x "$brew_bin" ]]; then
    warn "tree-sitter binary was not found after Homebrew install: $brew_bin"
    return 1
  fi

  current_version="$(tree_sitter_version "$brew_bin")"
  if ! version_ge "$current_version" "$min_version"; then
    warn "Homebrew tree-sitter-cli is too old: $current_version < $min_version"
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  ln -sfn "$brew_bin" "$HOME/.local/bin/tree-sitter"
  sudo ln -sfn "$brew_bin" /usr/local/bin/tree-sitter

  export PATH="$brew_prefix/bin:$HOME/.local/bin:$PATH"
  log "tree-sitter CLI active version: $(tree-sitter --version 2>/dev/null || true)"
}

install_official_neovim() {
  [[ "$INSTALL_OFFICIAL_NVIM" == "1" ]] || return 0

  local arch asset
  case "$(uname -m)" in
    x86_64|amd64)
      arch="x86_64"
      asset="nvim-linux-x86_64.tar.gz"
      ;;
    aarch64|arm64)
      arch="arm64"
      asset="nvim-linux-arm64.tar.gz"
      ;;
    *)
      warn "Unsupported Neovim official tarball architecture: $(uname -m). Skipping official /opt Neovim."
      return 0
      ;;
  esac

  local expected="/opt/nvim-linux-${arch}/bin/nvim"
  if [[ -x "$expected" ]]; then
    log "Official Neovim already present: $expected"
  else
    log "Installing official Neovim to /opt/nvim-linux-${arch}"
    local tmp
    tmp="$(mktemp -d)"
    curl -fL "https://github.com/neovim/neovim/releases/latest/download/${asset}" -o "$tmp/nvim.tar.gz"
    sudo rm -rf "/opt/nvim-linux-${arch}"
    sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
    rm -rf "$tmp"
  fi

  sudo ln -sfn "$expected" /usr/local/bin/nvim

  if [[ "$arch" == "x86_64" ]]; then
    # Neovide's tracked Windows config points at this path specifically.
    if [[ ! -e /opt/nvim-linux-x86_64/bin/nvim ]]; then
      warn "Expected Neovide path missing: /opt/nvim-linux-x86_64/bin/nvim"
    fi
  fi
}

install_shell_plugins() {
  log "Installing/updating zsh plugins and tmux TPM"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || warn "Oh My Zsh install failed"
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$zsh_custom/plugins" "$zsh_custom/themes" "$HOME/.tmux/plugins"

  clone_or_update() {
    local repo="$1" dest="$2"
    if [[ -d "$dest/.git" ]]; then
      git -C "$dest" pull --ff-only || warn "Could not update $dest"
    elif [[ -e "$dest" ]]; then
      warn "Exists but is not a git repo, skipping: $dest"
    else
      git clone --depth=1 "$repo" "$dest"
    fi
  }

  clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$zsh_custom/themes/powerlevel10k"
  clone_or_update "https://github.com/Aloxaf/fzf-tab.git" "$zsh_custom/plugins/fzf-tab"
  clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "$zsh_custom/plugins/zsh-autosuggestions"
  clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$zsh_custom/plugins/zsh-syntax-highlighting"
  clone_or_update "https://github.com/zsh-users/zsh-completions.git" "$zsh_custom/plugins/zsh-completions"
  clone_or_update "https://github.com/tmux-plugins/tpm.git" "$HOME/.tmux/plugins/tpm"
}

write_sioyek_wrapper() {
  log "Writing WSL Sioyek wrapper"
  mkdir -p "$HOME/.local/bin"
  cat > "$HOME/.local/bin/sioyek-wsl" <<'EOFSIOYEK'
#!/usr/bin/env bash
set -euo pipefail

args=()
for arg in "$@"; do
  if [[ "$arg" != -* && -e "$arg" ]]; then
    args+=("$(wslpath -w "$(realpath "$arg")")")
  else
    args+=("$arg")
  fi
done

exec sioyek.exe "${args[@]}"
EOFSIOYEK
  chmod +x "$HOME/.local/bin/sioyek-wsl"
}

link_dotfiles() {
  log "Linking WSL dotfiles"

  if [[ "$ROOT" != "$HOME/.dotfiles" ]]; then
    link_path "$ROOT" "$HOME/.dotfiles"
  fi

  link_path "$ROOT/common/nvim" "$HOME/.config/nvim"
  link_path "$ROOT/common/tmux/tmux.conf" "$HOME/.tmux.conf"
  link_path "$ROOT/common/shell/zsh/zshrc" "$HOME/.zshrc"
  link_path "$ROOT/common/shell/zsh/p10k.zsh" "$HOME/.p10k.zsh"
  link_path "$ROOT/common/shell/fastfetch" "$HOME/.config/fastfetch"
  link_path "$ROOT/common/lazygit" "$HOME/.config/lazygit"
}

set_zsh_default() {
  if have zsh && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)" || warn "Could not set zsh as default shell. You can run: chsh -s $(command -v zsh)"
  fi
}

run_lazy_sync() {
  [[ "$RUN_LAZY_SYNC" == "1" ]] || return 0
  if have nvim; then
    log "Running Neovim Lazy sync"
    nvim --headless "+Lazy! sync" +qa || warn "Lazy sync failed. Open nvim and run :Lazy manually."
  fi
}

doctor() {
  log "WSL doctor"
  echo "Root: $ROOT"
  echo "User: $(whoami)"
  echo
  echo "Commands:"
  for cmd in git zsh nvim tmux rg fd fzf fastfetch lazygit tree-sitter zoxide atuin eza bat node npm python3 jq shellcheck shfmt latexmk biber sioyek.exe sioyek-wsl wslpath explorer.exe clip.exe; do
    if command -v "$cmd" >/dev/null 2>&1; then
      printf '  [ok]   %-18s %s\n' "$cmd" "$(command -v "$cmd")"
    else
      printf '  [miss] %-18s\n' "$cmd"
    fi
  done
  echo
  echo "Links:"
  for pair in \
    "$HOME/.dotfiles::$ROOT" \
    "$HOME/.config/nvim::$ROOT/common/nvim" \
    "$HOME/.tmux.conf::$ROOT/common/tmux/tmux.conf" \
    "$HOME/.zshrc::$ROOT/common/shell/zsh/zshrc" \
    "$HOME/.p10k.zsh::$ROOT/common/shell/zsh/p10k.zsh" \
    "$HOME/.config/fastfetch::$ROOT/common/shell/fastfetch" \
    "$HOME/.config/lazygit::$ROOT/common/lazygit"; do
    dest="${pair%%::*}"
    src="${pair##*::}"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      printf '  [ok]   %-32s -> %s\n' "$dest" "$src"
    elif [[ -e "$dest" || -L "$dest" ]]; then
      printf '  [warn] %-32s exists but is not linked to %s\n' "$dest" "$src"
    else
      printf '  [miss] %-32s -> %s\n' "$dest" "$src"
    fi
  done
  echo
  if [[ -x /opt/nvim-linux-x86_64/bin/nvim ]]; then
    /opt/nvim-linux-x86_64/bin/nvim --version | head -n 1
  fi
}

main() {
  log "Repo root inside WSL: $ROOT"

  if [[ "$MODE" != "link" ]]; then
    install_apt_base
    install_latex
    install_linuxbrew
    install_tree_sitter_cli
    install_official_neovim
    install_shell_plugins
  fi

  write_sioyek_wrapper
  link_dotfiles
  set_zsh_default
  run_lazy_sync
  doctor
}

main "$@"
'@

    Write-Utf8NoBom -Path $scriptPath -Content $bash

    if ($DryRun) {
        Write-Host "[dry-run] convert $scriptPath to WSL path and run provisioner"
        return
    }

    if ((Get-WslDistroNames) -notcontains $DistroName) {
        throw "Cannot provision WSL because distro '$DistroName' is not registered. Run 'wsl -l -v' to inspect installed distros. If WSL was just enabled, reboot, install/open Debian once, then rerun this script."
    }

    $wslScriptPath = ConvertTo-WslPathLocal -Path $scriptPath
    $wslRepoRoot = ConvertTo-WslPathLocal -Path $script:RepoRoot
    if ([string]::IsNullOrWhiteSpace($wslScriptPath) -or [string]::IsNullOrWhiteSpace($wslRepoRoot)) {
        throw "Could not convert Windows paths to WSL paths. Script: $scriptPath; Repo: $script:RepoRoot"
    }

    $installLatex = if ($NoLatex) { "0" } else { "1" }
    $installLinuxbrew = if ($NoLinuxbrew) { "0" } else { "1" }
    $installOfficialNvim = if ($NoOfficialNeovim) { "0" } else { "1" }
    $runLazySync = if ($NoLazySync) { "0" } else { "1" }
    $wslMode = if ($NoInstall) { "link" } else { $Mode }

    Invoke-Native -File "wsl.exe" -Arguments @(
        "-d", $DistroName,
        "--", "bash", $wslScriptPath,
        $wslRepoRoot,
        $env:USERNAME,
        $wslMode,
        $installLatex,
        $installLinuxbrew,
        $installOfficialNvim,
        $runLazySync
    )
}

# -----------------------------------------------------------------------------
# Doctor
# -----------------------------------------------------------------------------

function Check-Path {
    param([string]$Label, [string]$Path)

    if (Test-Path $Path) {
        $target = Get-LinkTargetString $Path
        if ($target) {
            Write-Host ("  [ok]   {0,-32} {1} -> {2}" -f $Label, $Path, $target)
        } else {
            Write-Host ("  [ok]   {0,-32} {1}" -f $Label, $Path)
        }
    } else {
        Write-Host ("  [miss] {0,-32} {1}" -f $Label, $Path)
    }
}

function Check-Command {
    param([string]$Command)
    $found = Get-Command $Command -ErrorAction SilentlyContinue
    if ($found) {
        Write-Host ("  [ok]   {0,-20} {1}" -f $Command, $found.Source)
    } else {
        Write-Host ("  [miss] {0,-20}" -f $Command)
    }
}

function Invoke-Doctor {
    Write-Step "Windows doctor"
    Write-Host "Repo root: $script:RepoRoot"
    Write-Host "Mode:      $Mode"
    Write-Host "Distro:    $DistroName"
    Write-Host ""

    Write-Host "Commands:"
    foreach ($cmd in @("winget", "wsl", "wt", "neovide", "sioyek", "glazewm", "zebar", "AutoHotkey64", "AutoHotkeyUX")) {
        Check-Command $cmd
    }

    Write-Host ""
    Write-Host "Windows config paths:"
    Check-Path "GlazeWM config" (Join-Path $env:USERPROFILE ".glzr\glazewm\config.yaml")
    Check-Path "Zebar config dir" (Join-Path $env:USERPROFILE ".glzr\zebar")
    Check-Path "Windows Terminal settings" (Get-WindowsTerminalSettingsPath)
    Check-Path "PowerShell profile" $PROFILE
    Check-Path "Neovide config" (Join-Path $env:APPDATA "neovide\config.toml")
    Check-Path "NeovideWSL launcher" (Join-Path $env:LOCALAPPDATA "Programs\NeovideWSL\NeovideWSL.exe")
    Check-Path "Sioyek prefs" (Join-Path $env:APPDATA "sioyek\prefs_user.config")

    Write-Host ""
    Write-Host "WSL distros:"
    if (Test-CommandExists "wsl") {
        Invoke-Native -File "wsl.exe" -Arguments @("-l", "-v") -ContinueOnError | Out-Null
    } else {
        Write-Host "  [miss] wsl"
    }

    if (-not $NoWSL -and (Get-WslDistroNames) -contains $DistroName) {
        Write-Host ""
        Write-Host "WSL quick check:"
        Invoke-Native -File "wsl.exe" -Arguments @("-d", $DistroName, "--", "bash", "-lc", "command -v nvim; /opt/nvim-linux-x86_64/bin/nvim --version 2>/dev/null | head -n 1; test -L ~/.dotfiles && readlink ~/.dotfiles") -ContinueOnError | Out-Null
    }
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

function Main {
    Relaunch-AsAdminIfNeeded
    Resolve-RepoRoot

    if ($Mode -ne "doctor") {
        Test-SymlinkCapability
    }

    Install-WindowsPackages
    Ensure-WSLAndDebian
    Invoke-WslProvisioner
    Apply-WindowsConfigs
    Register-FileAssociations
    Invoke-Doctor

    Write-Step "Done"
    Write-Warn "Restart Windows Terminal and reload/restart GlazeWM and Zebar after a first full run. If WSL/Debian was installed for the first time, a reboot may be required before rerunning."
}

Main


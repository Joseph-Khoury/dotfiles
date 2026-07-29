# Native Windows PowerShell profile.
# Keep this minimal. Main dev shell is WSL/Zsh.

# Put Windows-only aliases/functions here.
function venv {
    $directories = ".venv", "venv"

    foreach ($directory in $directories) {
        $activate = Join-Path $PWD "$directory\Scripts\Activate.ps1"

        if (Test-Path $activate) {
            & $activate
            return
        }
    }

    $answer = Read-Host "No virtual environment found. Create .venv? [Y/N]"

    if ($answer -eq "" -or $answer -match "^[Yy]") {
        python -m venv .venv

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to create the virtual environment"
            return
        }

        $activate = Join-Path $PWD ".venv\Scripts\Activate.ps1"
        & $activate
    }
    else {
        Write-Host "Cancelled"
    }
}

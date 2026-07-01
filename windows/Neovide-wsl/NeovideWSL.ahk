#Requires AutoHotkey v2.0
#SingleInstance Off

; If `where neovide.exe` does not work, hard-code this:
; neovide := "C:\Program Files\Neovide\neovide.exe"

neovide := FindExe("neovide.exe")

neovideArgs := ["--wsl"]

; Optional:
; neovideArgs.Push("--no-tabs")

for arg in A_Args {
    if IsWindowsPath(arg) {
        neovideArgs.Push(WslPath(arg))
    } else {
        neovideArgs.Push(arg)
    }
}

Run(Quote(neovide) " " JoinArgs(neovideArgs))
ExitApp(0)


FindExe(name) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec("where.exe " name)
    out := Trim(exec.StdOut.ReadAll(), "`r`n `t")

    if out != "" {
        return StrSplit(out, "`r`n")[1]
    }

    MsgBox(
        "Could not find " name " on PATH.`n`n" .
        "Hard-code the Neovide path near the top of this script.",
        "Neovide WSL Launcher"
    )
    ExitApp(1)
}


IsWindowsPath(path) {
    ; Drive path: C:\...
    ; UNC path: \\server\share\...
    return RegExMatch(path, "i)^[A-Z]:\\") || SubStr(path, 1, 2) = "\\"
}


WslPath(winPath) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec("wsl.exe wslpath -a -- " Quote(winPath))

    out := Trim(exec.StdOut.ReadAll(), "`r`n")
    err := Trim(exec.StdErr.ReadAll(), "`r`n")

    if out = "" {
        MsgBox(
            "wslpath failed for:`n" winPath "`n`n" err,
            "Neovide WSL Launcher"
        )
        ExitApp(1)
    }

    return out
}


JoinArgs(args) {
    s := ""

    for arg in args {
        s .= (s ? " " : "") Quote(arg)
    }

    return s
}


Quote(s) {
    return '"' StrReplace(s, '"', '\"') '"'
}

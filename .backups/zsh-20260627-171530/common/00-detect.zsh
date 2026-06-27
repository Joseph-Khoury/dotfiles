export ZSH_OS="unknown"

case "$(uname -s)" in
    Darwin)
        export ZSH_OS="macos"
        ;;
    Linux)
        if grep -qi microsoft /proc/version 2>/dev/null; then
            export ZSH_OS="wsl"
        else
            export ZSH_OS="linux"
        fi
        ;;
esac

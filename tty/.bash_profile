# .bash_profile
#===============================================================================
#				   Functions
#===============================================================================
export_maybe_path()
{
    local dir="$1"
    if [[ -d "$dir" ]]; then
        case ":${PATH}:" in
            *":${dir}:"*)
                return 1
                ;;
            *)
                export PATH="${PATH}:${dir}"
                return 0
                ;;
        esac
    fi
}
#===============================================================================
#				     System
#===============================================================================
if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi

export_maybe_path "$HOME/.local/bin"
export_maybe_path "$HOME/bin"

if [[ -f ~/.bash.local ]]; then
    source ~/.bash.local
fi
#===============================================================================
#				  Environments
#===============================================================================
# Personal environment
#-------------------------------------------------------------------------------
export TTY_MOTTO="If there's a shell, there's a way."
export TTY_NICK="ttybitnik"
export TTY_NAME="Vinícius Moraes"
export TTY_EMAIL="vinicius.moraes@eternodevir.com"
export TTY_FINGERPRINT="0xD3ABD88652EA7D41"
export TTY_SIGNING="0xB52D1006EFAC93DF"
#-------------------------------------------------------------------------------
# System environment
#-------------------------------------------------------------------------------
export HISTCONTROL="ignoreboth"
export EDITOR="/usr/bin/emacsclient -c -n"
unset SSH_AGENT_PID
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSH_AUTH_SOCK
#-------------------------------------------------------------------------------
# Development environment
#-------------------------------------------------------------------------------
if command -v npm >/dev/null 2>&1; then
    export_maybe_path "${HOME}/.npm-global/bin" \
        && printf "prefix=%s/.npm-global\n" "${HOME}" >"${HOME}/.npmrc"
fi

if command -v go >/dev/null 2>&1; then
    export_maybe_path "${HOME}/.go/bin" \
        && export GOPATH="${HOME}/.go"
fi

if command -v cargo >/dev/null 2>&1; then
    export_maybe_path "${HOME}/.cargo/bin"
fi

if command -v pip3 >/dev/null 2>&1; then
    export_maybe_path "${HOME}/.pip/bin" \
        && export PYTHONUSERBASE="${HOME}/.pip"
fi

if command -v chicken-install >/dev/null 2>&1; then
    export_maybe_path "${HOME}/.chicken/bin" \
        && export CHICKEN_INSTALL_REPOSITORY="$HOME/.chicken"
fi
#-------------------------------------------------------------------------------
# Custom environment
#-------------------------------------------------------------------------------
export CUSTOM_HERMES="${TTY_DOTFILES}/tty/.config/hermes/motd.log"
export CUSTOM_SWITCHER="${TTY_DOTFILES}/.switcher_state"

case "$(uname -s)" in
    SunOS*)    CUSTOM_SYSTEM="SOLARIS" ;;
    Darwin*)   CUSTOM_SYSTEM="OSX" ;;
    Linux*)    CUSTOM_SYSTEM="LINUX" ;;
    FreeBSD*)  CUSTOM_SYSTEM="FREEBSD" ;;
    NetBSD*)   CUSTOM_SYSTEM="NETBSD" ;;
    OpenBSD*)  CUSTOM_SYSTEM="OPENBSD" ;;
    MINGW*)    CUSTOM_SYSTEM="MINGW" ;;
    MSYS*)     CUSTOM_SYSTEM="MINGW" ;;
    CYGWIN*)   CUSTOM_SYSTEM="CYGWIN" ;;
    *)         CUSTOM_SYSTEM="UNKNOWN" ;;
esac
if [[ "$CUSTOM_SYSTEM" == "LINUX" ]] \
       && grep -q '(Microsoft@Microsoft.com)' /proc/version 2>/dev/null; then
    CUSTOM_SYSTEM="Win11_Linux"
fi
export CUSTOM_SYSTEM

if command -v brew >/dev/null 2>&1; then
    CUSTOM_INSTALL="BREW"
elif command -v apt >/dev/null 2>&1; then
    CUSTOM_INSTALL="APT"
elif command -v dnf >/dev/null 2>&1; then
    CUSTOM_INSTALL="DNF"
elif command -v yum >/dev/null 2>&1; then
    CUSTOM_INSTALL="YUM"
elif command -v pacman >/dev/null 2>&1; then
    CUSTOM_INSTALL="PACMAN"
elif command -v apk >/dev/null 2>&1; then
    CUSTOM_INSTALL="APK"
elif command -v pkg >/dev/null 2>&1; then
    CUSTOM_INSTALL="PKG"
else
    CUSTOM_INSTALL="UNKNOWN"
fi
export CUSTOM_INSTALL
#===============================================================================
#				    Startup
#===============================================================================
cat "${CUSTOM_HERMES}"

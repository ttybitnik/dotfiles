# .bash_profile
#===============================================================================
#				     System
#===============================================================================
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
#===============================================================================
#				  Environments
#===============================================================================
# Personal environment
#-------------------------------------------------------------------------------
export TTY_DOTFILES="${HOME}/Remote/orpheus/git/dotfiles"
export TTY_SCRIPTS="${HOME}/.local/bin"
export TTY_GIT="${HOME}/Remote/orpheus/git"
export TTY_WALLPAPER="${HOME}/Pictures/Wallpapers"
export TTY_MOTTO="If there's a shell, there's a way."
export TTY_CITY="Juiz de Fora"
export TTY_GEO="-23.55:-46.63"
export TTY_NICK="ttybitnik"
export TTY_EMAIL="vinicius.moraes@eternodevir.com"
export TTY_FINGERPRINT="0xD3ABD88652EA7D41"
export TTY_SIGNING="0xB52D1006EFAC93DF"
#-------------------------------------------------------------------------------
# System environment
#-------------------------------------------------------------------------------
export HISTCONTROL="ignoreboth"
export EDITOR="/usr/bin/emacsclient -c -n"
unset SSH_AGENT_PID
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
#-------------------------------------------------------------------------------
# Development environment
#-------------------------------------------------------------------------------
if  [ -x "$(command -v npm)" ]; then
    export PATH="${PATH}:${HOME}/.npm-global/bin"
    printf "prefix=%s/.npm-global" "${HOME}" > "${HOME}/.npmrc"
fi

if  [ -x "$(command -v go)" ]; then
    export PATH="${PATH}:${HOME}/.go/bin"
    export GOPATH="${HOME}/.go"
fi

if  [ -x "$(command -v cargo)" ]; then
    export PATH="${PATH}:${HOME}/.cargo/bin"
fi

if  [ -x "$(command -v pip3)" ]; then
    export PATH="${PATH}:${HOME}/.pip/bin"
    export PYTHONUSERBASE="${HOME}/.pip"
fi
#-------------------------------------------------------------------------------
# Custom environment
#-------------------------------------------------------------------------------
export CUSTOM_HERMES="${TTY_DOTFILES}/tty/.config/hermes/motd.log"
export CUSTOM_SWITCHER="${TTY_DOTFILES}/.switcher_state"

case "$OSTYPE" in
    solaris*) CUSTOM_SYSTEM="SOLARIS" ;;
    darwin*)  CUSTOM_SYSTEM="OSX" ;;
    linux*)   CUSTOM_SYSTEM="LINUX" ;;
    bsd*)     CUSTOM_SYSTEM="BSD" ;;
    msys*)    CUSTOM_SYSTEM="MINGW" ;;
    cygwin*)  CUSTOM_SYSTEM="CYGWIN" ;;
    *)        CUSTOM_SYSTEM="UNKNOWN" ;;
esac
case "$(uname -s)" in
    Darwin)   CUSTOM_SYSTEM="OSX" ;;
    Linux)    CUSTOM_SYSTEM="LINUX" ;;
    FreeBSD)  CUSTOM_SYSTEM="FREE_BSD" ;;
    NetBSD)   CUSTOM_SYSTEM="NET_BSD" ;;
    OpenBSD)  CUSTOM_SYSTEM="OPEN_BSD" ;;
    MINGW*)   CUSTOM_SYSTEM="MINGW" ;;
    CYGWIN*)  CUSTOM_SYSTEM="CYGWIN" ;;
    *)        CUSTOM_SYSTEM="UNKNOWN" ;;
esac
if [[ "$CUSTOM_SYSTEM" == "LINUX" && \
	  -n "$(grep '(Microsoft@Microsoft.com)' /proc/version)" ]]; then
    CUSTOM_SYSTEM="Win11_Linux"
fi
export CUSTOM_SYSTEM

if which brew >/dev/null 2>&1; then
    CUSTOM_INSTALL="BREW"
fi
if which apt-get >/dev/null 2>&1; then
    CUSTOM_INSTALL="APT"
fi
if which yum >/dev/null 2>&1; then
    CUSTOM_INSTALL="YUM"
fi
export CUSTOM_INSTALL
#===============================================================================
#				    Systemd
#===============================================================================
systemctl --user import-environment \
	  PATH \
	  TTY_WALLPAPER \
	  TTY_MOTTO \
	  CUSTOM_HERMES \
	  CUSTOM_SWITCHER
#===============================================================================
#				    Startup
#===============================================================================
cat "${CUSTOM_HERMES}"

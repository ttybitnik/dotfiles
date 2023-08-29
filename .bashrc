# .bashrc
#===============================================================================
#				     System
#===============================================================================
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

GPG_TTY=$(tty)
export GPG_TTY
#===============================================================================
#				    Aliases
#===============================================================================
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
	if [ -f "$rc" ]; then
	    . "$rc"
	fi
    done
fi
unset rc
#===============================================================================
#				   Functions
#===============================================================================
function cd {
    builtin cd "$@" && pwd
}

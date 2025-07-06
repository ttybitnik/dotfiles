# .bash_aliases
#===============================================================================
#				    Defaults
#===============================================================================
alias ls='ls -hvF --color=auto --group-directories-first'
alias mv='mv -iv'
alias rm='rm -Iv'
alias cp='cp -irv'
alias mkdir='mkdir -v'
alias tree='tree -vF -I ".git" --dirsfirst'
alias grep='grep --color=auto'
alias diff='diff --color=auto --unified'
alias vi='vim'
alias emacs='emacsclient -c -n'
alias mpv='mpv --no-terminal'
alias qrencode='qrencode -t utf8i'
#===============================================================================
#				   Shortcuts
#===============================================================================
alias ll='ls -l'
alias lsa='ls -a'
alias lla='ls -la'
alias mkd='mkdir'
alias g='git'
alias c='clear'
alias chmox='chmod +x'
alias tn='tmux new'
alias ta='tmux attach'
alias tk='tmux kill-session'
alias cs='cryptsetup'
alias em='emacs'
alias yt='ytfzf --detach -f'
alias mol='molecule'
#===============================================================================
#				 Functionality
#===============================================================================
alias dotfiles='cd $TTY_DOTFILES'
alias scripts='cd $TTY_SCRIPTS'
alias repos='cd $TTY_GIT'
alias dired='emacsclient -c -n -e "(dired-jump)"'
alias magit='emacsclient -c -n -e "(progn (magit-status) (delete-other-windows))"'
alias pomodoro='emacsclient -n -e "(pomodoro/ttybitnik)"'
alias view='vi -R'
alias ?='lynx_duck'
alias ??='lynx_wiki'
alias fcd='cd $(find -type d | fzf)'
alias femacs='emacs $(find -type f | fzf)'
alias fpath='find -type f | fzf | sed 's/^..//g' \
      	        | tr -d '\n' | xclip -selection primary'
alias weather='curl -s https://wttr.in/"${TTY_CITY// /+}" | head -n -2'
#===============================================================================
#				    Private
#===============================================================================
if [ -f ~/.bash_aliases2 ]; then
    . ~/.bash_aliases2
fi

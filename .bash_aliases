alias lsa='ls -ah'
alias lla='ls -lah'
alias mv="mv -i"
alias rm="rm -i"
alias cp="cp -ir"
alias c='clear'
alias grep="grep --color"
alias chmox='chmod +x'

alias em='emacs'
alias emacs='emacsclient -c -n'
alias vi='vim'
alias view='vi -R'
alias mpv='devour mpv'
alias yt='ytfzf --detach -f'
alias tn='tmux new'
alias ta='tmux attach'
alias tk='tmux kill-session'
alias ?='lynx-duck'

alias fcd='cd $(find -type d | fzf)'
alias femacs='emacs $(find -type f | fzf)'
alias fpath='find -type f | fzf | sed 's/^..//g' | tr -d '\n' | xclip -selection primary'
alias dot='cd $HOME/.config/dotfiles'
alias scripts='cd $HOME/.local/bin'


alias weather='curl wttr.in/Juiz+de+fora | head -n -1'
. ~/.bash_aliases2

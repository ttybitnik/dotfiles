#!/bin/bash

gpg-agent --daemon &
xrdb ~/.Xresources &
~/.config/suckless/dwm/patch/dwmc xrdb & 
xsettingsd &
nitrogen --restore &
dwmblocks &
sxhkd &
\emacs &
redshift -l "$TTY_GEO" &
sleep 5
urxvt -e tmux &
sleep 5
qbit &

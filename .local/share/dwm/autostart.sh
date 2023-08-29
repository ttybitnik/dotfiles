#!/bin/bash

xrdb ~/.Xresources &
~/.config/suckless/dwm/patch/dwmc xrdb & 
xsettingsd &
nitrogen --restore &
dwmblocks &
sxhkd &
\emacs &
redshift -l -23.55:-46.63 &
sleep 5
urxvt -e tmux &
sleep 5
qbit &

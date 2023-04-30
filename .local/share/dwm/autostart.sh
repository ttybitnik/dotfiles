#!/bin/bash

export PATH="$HOME/.local/bin:$PATH" &
xrdb ~/.Xresources &
nitrogen --restore &
dwmblocks &
sxhkd &
/usr/bin/emacs &
redshift -l -23.55:-46.63 &
sleep 5
urxvt -e tmux &
sleep 5
qbit &

#!/bin/bash

xrdb ~/.Xresources &
export PATH="$HOME/.local/bin:$PATH" &
nitrogen --restore &
dwmblocks &
sxhkd &
/usr/bin/emacs &
sleep 2
urxvt -e tmux &
sleep 5
qbit &

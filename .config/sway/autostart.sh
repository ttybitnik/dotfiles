#!/bin/bash

gpg-agent --daemon &
gammastep -l "$TTY_GEO" &
sleep 5
foot -e tmux &
emacs &
firefox &
sleep 5
qbit &

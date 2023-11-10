#!/bin/bash

#===============================================================================
#				   WARNING
#-------------------------------------------------------------------------------
# This file is deprecated since 2023-11-09.
# Now the autostart.sh flow is dealt directly in Sway config file.
#===============================================================================
gpg-agent --daemon &
gammastep -l "$TTY_GEO" &
sleep 5
foot -e tmux &
emacs &
firefox &
sleep 5
qbit &

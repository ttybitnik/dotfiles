#!/usr/bin/env bash 

vol="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
printf '%3s' "$vol%"

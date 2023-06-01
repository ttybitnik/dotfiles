#!/usr/bin/env bash

W=$(curl -s https://wttr.in/Juiz-de-Fora?format="%t\n" | head -n 3)
printf '%5s' "$W"

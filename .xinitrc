#!/usr/bin/env bash

source ~/.secret

export DE="xfce"
export OOO_FORCE_DESKTOP="xfce4"
export BROWSER="brave-browser"
export TERMINAL="urxvtc"
export QT_STYLE_OVERRIDE="gtk2"
export CM_LAUNCHER="rofi"
export CM_IGNORE_WINDOW="fpass"

# set screen blank timeout to 1 hour
which xset && xset s 3600 3600
# Disable system bell
xset b off
# Keyboard layout
setxkbmap -layout pl

# Start awesome
exec awesome > ~/.awesome_stdout 2> ~/.awesome_stderr

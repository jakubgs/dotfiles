#!/bin/bash

source ~/.secret

#export VDPAU_DRIVER=nvidia
export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export QT_STYLE_OVERRIDE="gnome"

# adjust screen setup before you start awesome
#autorandr -c

# turn off touchpad by default
#synclient TouchpadOff=1

# gnu gpg agent
#systemctl --user start gpg-agent

# start the ssh-agent
systemctl --user start ssh-agent

# set screen blank timeout to 1 hour
xset s 3600 3600

# set trackpoint sensitivity
echo 80 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed
echo 250 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity

# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xcape

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

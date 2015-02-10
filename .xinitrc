#!/bin/bash

source ~/.secret

#export VDPAU_DRIVER=nvidia
export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"

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

# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xcape

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

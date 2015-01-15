#!/bin/bash

source ~/.secret

export VDPAU_DRIVER=nvidia
export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"

# adjust screen setup before you start awesome
#autorandr -c

# turn off touchpad by default
#synclient TouchpadOff=1

# start ssh agent and save variables
ssh-agent | grep -v echo > ~/.ssh-agent.env

# gnu gpg agent
gpg-agent --daemon --write-env-file="$HOME/.gnupg/gpg-agent-info"

# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xcape

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

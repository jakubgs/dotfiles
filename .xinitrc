#!/usr/bin/env bash

source ~/.secret

export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export QT_STYLE_OVERRIDE="gtk2"
export NVIM_LISTEN_ADDRESS="127.0.0.1:33333"

# set screen blank timeout to 1 hour
which xset && xset s 3600 3600

# set trackpoint sensitivity
echo 80 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed
echo 250 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity

# Keyboard layout
setxkbmap -layout pl

# gnu gpg agent
#export $(gpg-agent --daemon)
# start the ssh-agent
eval $(ssh-agent)

# Start awesome
ck-launch-session awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

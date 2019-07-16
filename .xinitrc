#!/usr/bin/env bash

source ~/.secret

export DE="xfce"
export OOO_FORCE_DESKTOP="xfce4"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export QT_STYLE_OVERRIDE="gtk2"
export MPD_HOST="localhost"

# set screen blank timeout to 1 hour
which xset && xset s 3600 3600
# Disable system bell
xset b off
# Keyboard layout
setxkbmap -layout pl

# gnu gpg agent
export $(gpg-agent --daemon)
# start the ssh-agent
#eval $(ssh-agent)

# Start awesome
#exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr
exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

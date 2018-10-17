#!/usr/bin/env bash

source ~/.secret

export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export QT_STYLE_OVERRIDE="gtk2"
export NVIM_LISTEN_ADDRESS="127.0.0.1:33333"
# Status.im QT config
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCREEN_SCALE_FACTOR=0.9
export QT_SCALE_FACTOR=0.7

# set screen blank timeout to 1 hour
which xset && xset s 3600 3600
# Disable system bell
xset b off
# Keyboard layout
setxkbmap -layout pl
# Caps Lock <-> Esc
#xmodmap ~/.speedswapper

# gnu gpg agent
#export $(gpg-agent --daemon)
# start the ssh-agent
eval $(ssh-agent)

# Start awesome
#exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr
#exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

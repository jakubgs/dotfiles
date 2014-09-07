export VDPAU_DRIVER=nvidia
export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"

# start ssh agent and save variables
ssh-agent | grep -v echo > ~/.ssh-agent.env

# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xmodmap .speedswapper
xcape -e 'Control_R=Escape'

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

export VDPAU_DRIVER=nvidia
export OOO_FORCE_DESKTOP="xfce4"
export DE="xfce"
export BROWSER="thunar"
export TERMINAL="urxvtc"

# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xmodmap .speedswapper
xcape

# Small hack for java compatibility
wmname LG3D

# start udevil to monitor for devices(for thunar)
devmon &

# Start awesome
exec awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr

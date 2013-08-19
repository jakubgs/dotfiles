# Keyboard layout
setxkbmap -layout pl

export TERMINAL="~/bin/urxvtb"
# Caps Lock <-> Esc
#xmodmap .speedswapper
#setxkbmap -option caps:escape

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec awesome --no-argb >> ~/.awesome_stdout 2>> ~/.awesome_stderr

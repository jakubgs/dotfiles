export TERMINAL="urxvtc"

# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xmodmap .speedswapper
xcape

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec awesome --no-argb >> ~/.awesome_stdout 2>> ~/.awesome_stderr

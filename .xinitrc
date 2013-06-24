# Keyboard layout
setxkbmap -layout pl

# Caps Lock <-> Esc
xmodmap .speedswapper

# Small hack for java compatibility
wmname LG3D

# Start awesome
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome --no-argb

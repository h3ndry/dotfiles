#!/bin/sh
#

VAR1=$(xrandr | rg -o 'HDMI-1 connected')
VAR2="HDMI-1 connected"

if [ "$VAR1" = "$VAR2" ]; then
    xrandr --auto && xrandr --output eDP-1 --off && xmodmap ~/.Xmodmap
else
    xrandr --auto 
fi

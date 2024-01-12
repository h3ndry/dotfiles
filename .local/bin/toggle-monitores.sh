#!/bin/sh
#

VAR1=$(xrandr | rg -o 'HDMI-1 connected')
VAR2="HDMI-1 connected"

if [ "$VAR1" = "$VAR2" ]; then
    xrandr --auto && xrandr --output eDP-1 --off && xmodmap ~/.Xmodmap
    sed -E -i 's/(size = )[0-9]+.[0-9]+/\111.5/' .config/alacritty/alacritty.toml
else
    xrandr --auto
    sed -E -i 's/(size = )[0-9]+.[0-9]+/\17.5/' .config/alacritty/alacritty.toml
fi

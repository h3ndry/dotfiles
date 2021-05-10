#!/bin/sh
#
#
dunst &
sxhkd &
slstatus &
mpd &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &
# feh --no-fehbg --bg-fill '/home/hendry/Pictures/wallhaven-l33vdl.jpg'

# if [ -d /etc/X11/xinit/xinitrc.d ]; then
#   for f in /etc/X11/xinit/xinitrc.d/*; do
#     [-x "$f" ] && . "&f"
#   done
# unset f
# fi

exec dwm

    

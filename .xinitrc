#!/bin/sh

dunst &
sxhkd &
slstatus &
systemctl --user start mpd &
xautolock -time 8 -locker slock &
xbanish &
picom &
 # lxsession &
clipmenud &
# ./.local/bin/05-1440x900-res.sh &
~/.local/bin/toggle-monitores.sh &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &
feh --no-fehbg --bg-fill '/home/hendry/Pictures/Wallpapers/11.png'
# feh --no-fehbg --bg-fill '/home/hendry/Pictures/wallpaper.jpg' &
export _JAVA_AWT_WM_NONREPARENTING=1

# if [ -d /etc/X11/xinit/xinitrc.d ]; then
#   for f in /etc/X11/xinit/xinitrc.d/*; do
#     [-x "$f" ] && . "&f"
#   done
# unset f

# fi
 exec dwm
 # exec leftwm

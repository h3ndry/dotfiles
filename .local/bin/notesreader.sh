#!/bin/sh

# file=$(find ~/workspace/notes/ | sort -r | head -n1)
dir=~/Documents/notes/

alacritty -T "NNN - File Mananger" --class "NNN" -e nnn

# alacritty -e nnn

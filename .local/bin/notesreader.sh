#!/bin/sh

# file=$(find ~/workspace/notes/ | sort -r | head -n1)
dir=~/Documents/notes/

alacritty -T "Notes" --class "Notes" -e nvim $dir --cmd "cd $dir"

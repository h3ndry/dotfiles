#!/bin/sh

# file=$(find ~/workspace/notes/ | sort -r | head -n1)
dir=~/workspace/notes/

alacritty -T "Notes" --class "Notes" -e nvim $dir --cmd "cd $dir" 

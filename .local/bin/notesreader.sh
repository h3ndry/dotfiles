#!/bin/sh

# file=$(find ~/workspace/notes/ | sort -r | head -n1)
dir=~/workspace/notes/

st -t "Notes" -c "Notes" -e nvim $dir --cmd "cd $dir"

#!/usr/bin/env bash

BASE='/home/hendry/'

items=`fd --max-depth=1 --type=d --base-directory=${BASE}  . 'workspace'`
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . 'playground'`
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . '.config'`

FOLDER=`echo "$items" | dmenu`

if [ -d "$FOLDER" ]; then
    st -t "Neovim $FOLDER" -c "NIDE"  -e nvim ${BASE}${FOLDER} --cmd "cd ${BASE}$FOLDER" 
fi

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'

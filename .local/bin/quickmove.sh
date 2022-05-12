#!/usr/bin/env bash

items=`fd --max-depth=1 --type=d  --min-depth=1 . '/home/hendry/workspace'`
items+=`fd --max-depth=1 --type=d  --min-depth=1 . '/home/hendry/playground'`
items+=`fd --max-depth=1 --type=d  --min-depth=1 . '/home/hendry/.config'`

FOLDER=`echo "$items" | dmenu`

if [ -d "$FOLDER" ]; then
    st -t "Neovim $FOLDER" -c "NIDE"  -e nvim ${FOLDER} --cmd "cd $FOLDER" 
fi

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'

#!/usr/bin/env bash

items=`find ~/workspace -maxdepth 1 -mindepth 1 -type d`
items+=`find ~/playground -maxdepth 1 -mindepth 1 -type d`
items+=`find ~/.config -maxdepth 1 -mindepth 1 -type d`
# items+=`find ~ -maxdepth 1 -mindepth 1 -type d`

FOLDER=`echo "$items" | dmenu`

if [ -d "$FOLDER" ]; then
    st -t "Neovim $FOLDER" -e nvim ${FOLDER} --cmd "cd $FOLDER" 
fi

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'

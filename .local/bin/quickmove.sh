#!/usr/bin/env bash

items=`find ~/workspace -maxdepth 1 -mindepth 1 -type d`
items+=`find ~/playround -maxdepth 1 -mindepth 1 -type d`
items+=`find ~/.config -maxdepth 1 -mindepth 1 -type d`
# items+=`find ~ -maxdepth 1 -mindepth 1 -type d`

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'
echo "$items" | dmenu | xargs -I {} st -e nvim {} --cmd 'cd {}'

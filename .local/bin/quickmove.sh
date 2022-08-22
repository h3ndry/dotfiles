#!/usr/bin/env bash

BASE='/home/hendry/'
COMPANY='/home/hendry/'

# for personal files and all that kind of staff I mess with
items=`fd --max-depth=1 --type=d --base-directory=${BASE}  . 'workspace'`
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . 'playground'`
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . '.config'`

# for a company specific projects
items+=`fd --hidden --type=directory --base-directory=/home/hendry/workspace/kriterion "\.git" | sd '\.git/' '' | sd '^\.' 'workspace/kriterion'`

FOLDER=`echo "$items" | dmenu`

if [ -d "$FOLDER" ]; then
	n="$(echo ${FOLDER} | sed 's/\/$//')"
	n="$(echo ${n} | sed 's/\//->/g')"
    st -t "neovim - $n" -c "NIDE"  -e nvim ${BASE}${FOLDER} --cmd "cd ${BASE}$FOLDER"
fi

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'

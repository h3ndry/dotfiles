#!/usr/bin/env bash

export OPENAI_API_KEY="$(cat ~/.jshi)"
BASE='/home/hendry/'
COMPANY='/home/hendry/'


# for personal files and all that kind of staff I mess with
items=`fd --max-depth=1 --type=d --base-directory='/run/media/hendry/2CFA-18FF/' . 'Code'`
items+=$'\n'
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . '.config'`
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . 'workspace'`

items+=$'\n'


# for a company specific projects
items+=`fd --hidden --type=directory --base-directory=/home/hendry/workspace/kriterion "\.git" | sd '\.git/' '' | sd '(^\w)' 'workspace/kriterion/$1'`

items+=`fd --hidden --type=directory --base-directory=/home/hendry/workspace/hackerthon "\.git" | sd '\.git/' '' | sd '(^\w)' 'workspace/hackerthon/$1'`



FOLDER=`echo "$items" | rofi -dmenu`

if [ -d "$FOLDER" ]; then
	n="$(echo ${FOLDER} | sed 's/\/$//')"
	n="$(echo ${n} | sed 's/\//->/g')"

    echo ${n}

    # EXT=`fd -e py --base-directory=${BASE}${FOLDER}`

    alacritty -T "neovim - $n" --class "NIDE"  -e nvim ${BASE}${FOLDER} --cmd "cd ${BASE}${FOLDER}"
fi

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'

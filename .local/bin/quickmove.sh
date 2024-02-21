#!/usr/bin/env bash

export OPENAI_API_KEY="$(cat ~/.jshi)"
BASE='/home/hendry/'
COMPANY='/home/hendry/'


# for personal files and all that kind of staff I mess with
items=`fd --max-depth=1 --type=d --base-directory=${BASE} . 'Code'`
items+=$'\n'
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . 'workspace'`
items+=$'\n'
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . '.config'`
items+=$'\n'
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . '.local/share/nvim/lazy'`
items+=$'\n'
items+=`fd --max-depth=1 --type=d  --base-directory=${BASE} . 'workspace/hackerthon'`

items+=$'\n'
# for a company specific projects
items+=`fd -H -I --type=directory --base-directory=/home/hendry/workspace/kriterion -E ".github" "\.git" | sd '\.git/' '' | sd '(^\w)' 'workspace/kriterion/$1'`
items+=$'\n'



FOLDER=`echo "$items" | rofi -dmenu`

if [ -d "$FOLDER" ]; then
	n="$(echo ${FOLDER} | sed 's/\/$//')"
	n="$(echo ${n} | sed 's/\//->/g')"

    echo ${n}

    # EXT=`fd -e py --base-directory=${BASE}${FOLDER}`

    alacritty -T "neovim - $n" --class "NIDE"  -e nvim ${BASE}${FOLDER} --cmd "cd ${BASE}${FOLDER}"
fi

# echo "$items" | fzf | xargs -I {} nvim {} --cmd 'cd {}'

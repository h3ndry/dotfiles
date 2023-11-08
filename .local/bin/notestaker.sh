#!/bin/sh

noteFilename="$HOME/workspace/my-notes/$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "# [$(date +%Y-%m-%d)] - Notes " > $noteFilename
  echo "

## On my mind 🤯
- []

## Interesting 💭
- []

## Today's Goals 🚀
- [] " >> $noteFilename

fi

alacritty -T "Notes" --class "Notes" -e nvim --cmd "cd ${HOME}/workspace/my-notes" \
  -c "norm zz" $noteFilename


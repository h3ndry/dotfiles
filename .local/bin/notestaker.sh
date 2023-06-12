#!/bin/sh

noteFilename="$HOME/workspace/notes/note-$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "Notes For $(date +%Y-%m-%d)" > $noteFilename
  echo "====================" >> $noteFilename
  echo "" >> $noteFilename
fi

alacritty -T "Notes" --class "Notes" -e nvim -c "norm Go" \
  -c "norm zz" \
  -c "startinsert" $noteFilename



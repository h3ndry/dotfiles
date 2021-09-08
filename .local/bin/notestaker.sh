#!/bin/sh

noteFilename="$HOME/workspace/notes/note-$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "Notes For $(date +%Y-%m-%d)" > $noteFilename
  echo "====================" >> $noteFilename
  echo "" >> $noteFilename
fi

st -t "Notes" -c "Notes" -e nvim -c "norm Go" \
  -c "norm Go[$(date +%H:%M)] '<note title>'" \
  -c "norm Go----------------------" \
  -c "norm Go" \
  -c "norm Go" \
  -c "norm zz" \
  -c "startinsert" $noteFilename



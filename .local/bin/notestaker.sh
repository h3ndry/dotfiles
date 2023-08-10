#!/bin/sh

noteFilename="$HOME/Code/my-notes/note-$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "[$(date +%Y-%m-%d)]" > $noteFilename
  echo "# On my mind | Interesting | Todos" >> $noteFilename
  echo "---" >> $noteFilename
fi

alacritty -T "Notes" --class "Notes" -e nvim -c "norm Go" \
  -c "norm Go[$(date +%H:%M)]" \
  -c "norm Go---" \
  -c "norm Go" \
  -c "norm zz" $noteFilename


# st -t "Notes" -c "Notes" -e nvim -c "norm Go" \
#   -c "norm Go[$(date +%H:%M)] '<note title>'" \
#   -c "norm Go----------------------" \
#   -c "norm Go" \
#   -c "norm zz" \
#   -c "startinsert" $noteFilename


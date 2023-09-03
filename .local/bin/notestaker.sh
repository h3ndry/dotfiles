#!/bin/sh

noteFilename="$HOME/workspace/my-notes/$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "[$(date +%Y-%m-%d)]" > $noteFilename
  echo "# On my mind | Interesting | Todos" >> $noteFilename
  echo "---" >> $noteFilename
fi

alacritty -T "Notes" --class "Notes" -e nvim --cmd "cd ${HOME}/workspace/my-notes" -c "norm Go" \
  -c "norm Go[$(date +%H:%M)]" \
  -c "norm Go---" \
  -c "norm Go" \
  -c "norm zz" $noteFilename


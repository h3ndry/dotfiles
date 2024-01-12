#!/bin/sh

noteFilename="$HOME/workspace/my-notes/$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "## Notes - [$(date +%Y-%m-%d)] " > $noteFilename
  echo "

### On my mind 🤯
- [ ] _first, something on my mind._

### Interesting 💭
- [ ]  _first, something interesting._

### Today's Goals 🚀
- [ ] _first gaol_
" >> $noteFilename

fi

alacritty -T "Notes" --class "Notes" -e nvim --cmd "cd ${HOME}/workspace/my-notes" \
  -c "norm zz" $noteFilename


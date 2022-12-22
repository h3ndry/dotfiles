#!/bin/sh

SNIPS=${HOME}/.config/snippets/snippets.txt

DATA=`bat ${SNIPS} | dmenu`

if [ ${DATA} ]; then
  printf "$DATA" | xsel -p -i
  printf "$DATA" | xsel -b -i
  xdotool key shift+Insert
fi

#!/bin/sh

SNIPS=${HOME}/.config/snippets

FILE=`fd --base-directory=${SNIPS} . | dmenu`

if [ -f ${SNIPS}/${FILE} ]; then
  DATA=$([ -x "${SNIPS}/${FILE}" ] && bash "${SNIPS}/${FILE}" || head --bytes=-1 ${SNIPS}/${FILE})
  printf "$DATA" | xsel -p -i 
  printf "$DATA" | xsel -b -i 
  xdotool key shift+Insert
fi

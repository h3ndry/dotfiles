#!/bin/sh

SNIPS_FILE=${HOME}/.config/snippets/snippets.txt

DATA=`sed -r 's/::.*$//g' ${SNIPS_FILE} | rofi -dmenu -i`

if [[ -n "$DATA" ]]; then
    VALUE=`sed -n "s/^$DATA:://p" $SNIPS_FILE`
    printf "$VALUE" | xsel -p -i
    printf "$VALUE" | xsel -b -i
    xdotool key shift+Insert
fi

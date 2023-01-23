#!/bin/sh

SNIPS_FILE=${HOME}/.config/snippets/snippets.txt


DATA=`sed -r 's/::.*$//g' ${SNIPS_FILE} | dmenu`

if [ ${DATA} ]; then
    VALUE=`sed -rn "s/(^$DATA::)//p" $SNIPS_FILE`
    printf "$VALUE" | xsel -p -i
    printf "$VALUE" | xsel -b -i
    xdotool key shift+Insert
fi

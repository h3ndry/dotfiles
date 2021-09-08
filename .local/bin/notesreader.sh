#!/bin/sh

file=$(find ~/workspace/notes/ | sort -r | head -n1)

st -t "Notes" -c "Notes" -e sh -c "bat $file; read"

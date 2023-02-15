#!/bin/sh

LATEST_IMG="Okay we are just making progress"

maim --select "$HOME/Pictures/Screenshots/$(date).png"

BASE_PATH="$HOME/Pictures/Screenshots/"

LATEST_IMG="$( exa --sort=modified $BASE_PATH | tail -1 )"

tesseract "$BASE_PATH/$LATEST_IMG" stdout | xclip -selection clipboard


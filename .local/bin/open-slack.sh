#!/bin/sh

window_address=$(hyprctl clients -j | jq -r '.[] | select(.class == "Slack" or .class == "slack") | .address' | head -n 1)

if hyprctl activewindow 2>/dev/null | grep -q "special:special"; then
    hyprctl dispatch togglespecialworkspace special
fi

if [ -z "$window_address" ]; then
    slack
else
    workspace_id=$(hyprctl clients -j | jq -r '.[] | select(.class == "Slack" or .class == "slack") | .workspace.id' | head -n 1)
    hyprctl dispatch workspace "$workspace_id"
    hyprctl dispatch focuswindow "$window_address"
fi

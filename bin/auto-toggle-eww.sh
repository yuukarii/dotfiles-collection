#!/usr/bin/bash

LOCKFILE="/tmp/auto-toggle-eww-bar.lock"
INTERVAL=5

if [ -e "$LOCKFILE" ]; then
  echo "Script is already running"
  exit 1
fi

# Create the lock file
touch "$LOCKFILE"

# Ensure the lock file is removed when the script exits
trap 'rm -f "$LOCKFILE"' EXIT

# Listen for window state changes
while true; do
    sleep $INTERVAL
    # i3-msg -t subscribe '[ "window" ]' | while read -r _; do
    # Check if any window is fullscreen
    fullscreen=$(i3-msg -t get_tree | jq '.. | objects | select(.type? == "con" and .fullscreen_mode? == 1)')
    output=$(~/.local/bin/eww active-windows)
    date=$(date)
    fullscreen_status=$(echo $fullscreen | grep -q fullscreen_mode)
    echo "$date - Status: $fullscreen_status"
    echo "Active windows: $output"
    if [[ -n "$fullscreen" && "$output" == *"bar"* ]]; then
        # Hide Eww bar if a fullscreen window is detected
        ~/.local/bin/eww close bar
        echo "Closing bar"
    elif ! [[ -n "$fullscreen" || "$output" == *"bar"* ]]; then
        ~/.local/bin/eww open bar
        echo "Openning bar"
    fi
done
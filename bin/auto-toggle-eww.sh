#!/usr/bin/bash

LOCKFILE="/tmp/auto-toggle-eww-bar.lock"

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
    sleep 10
    # i3-msg -t subscribe '[ "window" ]' | while read -r _; do
    # Check if any window is fullscreen
    fullscreen=$(i3-msg -t get_tree | jq '.. | objects | select(.type? == "con" and .fullscreen_mode? == 1)')
    date=$(date)
    echo "$date - Status: $fullscreen"
    if [[ -n "$fullscreen" ]]; then
        # Hide Eww bar if a fullscreen window is detected
        ~/.local/bin/eww close bar
    else
        ~/.local/bin/eww open bar
    fi
done
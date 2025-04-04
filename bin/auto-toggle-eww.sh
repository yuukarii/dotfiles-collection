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

# Path to store last known HDMI status
STATUS_FILE="/tmp/hdmi1_status"

# Script to run when HDMI status changes
ACTION_SCRIPT="$HOME/.config/bin/bin/monitor-management.sh"

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

    # Auto connect new monitor
    # Read the last status from the status file, or set to "unknown" if file doesn't exist
    if [[ -f "$STATUS_FILE" ]]; then
        LAST_STATUS=$(cat "$STATUS_FILE")
    else
        LAST_STATUS="unknown"
    fi

    # Get current HDMI-1 status using xrandr
    CURRENT_STATUS=$(xrandr | grep "^HDMI-1" | awk '{print $2}')

    # Compare current status with last status
    if [[ "$CURRENT_STATUS" != "$LAST_STATUS" ]]; then
        echo "HDMI-1 status changed from $LAST_STATUS to $CURRENT_STATUS"
        echo "$CURRENT_STATUS" > "$STATUS_FILE"

        # Run the action script
        if [[ -x "$ACTION_SCRIPT" ]]; then
            "$ACTION_SCRIPT" "$CURRENT_STATUS"
        else
            echo "Action script not found or not executable: $ACTION_SCRIPT"
        fi
        i3-msg restart
    fi
done
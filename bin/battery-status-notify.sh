#!/usr/bin/bash

LOCKFILE="/tmp/battery-status-notify.lock"
INTERVAL=5

if [ -e "$LOCKFILE" ]; then
  echo "Script is already running"
  exit 1
fi

# Create the lock file
touch "$LOCKFILE"

# Ensure the lock file is removed when the script exits
trap 'rm -f "$LOCKFILE"' EXIT

STATUS=$(cat /sys/class/power_supply/BAT0/status)

while true; do
  sleep $INTERVAL
  LAST_STATUS=$STATUS
  STATUS=$(cat /sys/class/power_supply/BAT0/status)
  if [[ "$LAST_STATUS" != "$STATUS" ]]; then
    dunstify -a "changeBattery" -t 3000 -u low -h string:x-dunst-stack-tag:battery \
      "Battery status: ${STATUS}"
  fi
done

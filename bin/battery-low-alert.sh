#!/usr/bin/bash

LOCKFILE="/tmp/battery-low-alert.lock"

if [ -e "$LOCKFILE" ]; then
  echo "Script is already running"
  exit 1
fi

# Create the lock file
touch "$LOCKFILE"

# Ensure the lock file is removed when the script exits
trap 'rm -f "$LOCKFILE"' EXIT

LOW_LIMIT=20

while true; do
  STATUS=$(cat /sys/class/power_supply/BAT0/status)
  CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
  if [[ "$STATUS" == "Discharging" ]]; then
    if [[ "$CAPACITY" -lt "$LOW_LIMIT" ]]; then
      dunstify -a "battery_alert" -t 5000 -u critical -h string:x-dunst-stack-tag:battery_alert \
        "Battery low, please charge now"
    fi
  fi
  sleep 120
done

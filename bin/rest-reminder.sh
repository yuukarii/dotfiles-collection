#!/usr/bin/bash

LOCKFILE="/tmp/rest-reminder-alert.lock"

if [ -e "$LOCKFILE" ]; then
  echo "Script is already running"
  exit 1
fi

# Create the lock file
touch "$LOCKFILE"

# Ensure the lock file is removed when the script exists
trap 'rm -f "$LOCKFILE"' EXIT

INTERVAL_TIME=30 # In minutes

while true; do
  INTERVAL_TIME_SECONDS=$((INTERVAL_TIME*60))
  sleep $INTERVAL_TIME_SECONDS
  dunstify -t 300000 "Take a rest. You have sit in front of laptop too long" -u critical
done
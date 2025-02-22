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

INTERVAL_TIME=20 # In minutes

while true; do
  INTERVAL_TIME_SECONDS=$((INTERVAL_TIME*60))
  sleep $INTERVAL_TIME_SECONDS
  dunstify -t 20000 "Please take a look around for 20 seconds" -u critical
done

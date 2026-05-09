#!/bin/sh

MSG_TAG="brightness_change"

case $1 in
"--up")
  brightnessctl -q set +5%
  BRIGHTNESS_LEVEL=$(brightnessctl info | awk -F'[()]' '/Current/{gsub(/%/,"",$2); print $2}')
  dunstify -a "changeBrightness" -t 1000 -u low -h string:x-dunst-stack-tag:$MSG_TAG \
    -h int:value:"$BRIGHTNESS_LEVEL" "Brightness: ${BRIGHTNESS_LEVEL}%"
  ;;
"--down")
  brightnessctl -q set 5%-
  BRIGHTNESS_LEVEL=$(brightnessctl info | awk -F'[()]' '/Current/{gsub(/%/,"",$2); print $2}')
  dunstify -a "changeBrightness" -t 1000 -u low -h string:x-dunst-stack-tag:$MSG_TAG \
    -h int:value:"$BRIGHTNESS_LEVEL" "Brightness: ${BRIGHTNESS_LEVEL}%"
  ;;
esac

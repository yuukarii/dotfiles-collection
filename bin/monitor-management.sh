#!/bin/bash
monitor_info=$(xrandr | grep connected | grep -v disconnected)
# echo "$monitor_info"

if echo "$monitor_info" | grep -q "HDMI-1"; then
  echo "HDMI-1 found. Switch to HDMI-1"
  xrandr --output HDMI-1 --auto --primary
  #xrandr --output eDP-1 --auto --left-of HDMI-1
  xrandr --output eDP-1 --off
else
  echo "Don't found external monitor. Turn off HDMI-1"
  xrandr --output eDP-1 --auto --primary
  xrandr --output HDMI-1 --off
fi

#!/bin/bash
monitor_info=$(xrandr | grep connected | grep -v disconnected)

if echo "$monitor_info" | grep -q "HDMI-1"; then
  echo "HDMI-1 found. Switch to HDMI-1"
  xrandr --output eDP-1 --off
  xrandr --output HDMI-1 --auto --primary
else
  xrandr --output eDP-1 --auto --primary
  xrandr --output HDMI-1 --off
fi

#!/bin/bash
monitor_info=$(xrandr | grep connected | grep -v disconnected)

if echo "$monitor_info" | grep -q "HDMI-1"; then
    echo "HDMI-1 found. Switch to HDMI-1"
    xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1
else
    xrandr --output eDP-1 --auto
fi

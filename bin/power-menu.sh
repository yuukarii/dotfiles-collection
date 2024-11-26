#!/usr/bin/env bash

## Original Author : Aditya Shakya (adi1090x)
#
## Current Author : Jackson Novak (Oglo12)
#
## Github : @adi1090x
#
## Codeberg : @Oglo12
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5
## style-6   style-7   style-8   style-9   style-10

# Current Theme
dir="$HOME/.config/rofi"
theme='powermenu'

# Options
shutdown='   Shutdown'
reboot='   Reboot'
lock='   Lock'
suspend='󰤄   Suspend'
logout='󰍃   Logout'
yes='   Yes'
no='   No'

# Rofi CMD
rofi_cmd() {
  rofi -theme $HOME/.config/rofi/powermenu.rasi -dmenu -p 'Power'
}

# Confirmation CMD
confirm_cmd() {
  # rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 300px;}' \
  rofi \
    \
    -dmenu \
    -p 'Confirm' \
    -mesg 'Are you Sure?' \
    \
    -theme $HOME/.config/rofi/powermenu.rasi
}

# Ask for confirmation
confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
  # selected="$yes"
  selected="$(confirm_exit)"
  echo "$selected"
  if [[ "$selected" == "$yes" ]]; then
    if [[ $1 == '--shutdown' ]]; then
      dunstify -a "poweroff" -t 3000 -u low -h string:x-dunst-stack-tag:poweroff \
        "Shutting down ..."
      poweroff
    elif [[ $1 == '--reboot' ]]; then
      dunstify -a "reboot" -t 3000 -u low -h string:x-dunst-stack-tag:reboot \
        "Rebooting ..."
      reboot
    elif [[ $1 == '--suspend' ]]; then
      dunstify -a "suspend" -t 3000 -u low -h string:x-dunst-stack-tag:suspend \
        "Suspending ..."
      mpc -q pause
      amixer set Master mute
      systemctl suspend
    elif [[ $1 == '--logout' ]]; then
      pkill -KILL -u $USER
    fi
  else
    exit 0
  fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
  run_cmd --shutdown
  ;;
$reboot)
  run_cmd --reboot
  ;;
$lock)
  betterlockscreen -l
  ;;
$suspend)
  run_cmd --suspend
  ;;
$logout)
  run_cmd --logout
  ;;
esac

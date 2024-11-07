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
    -theme $HOME/.config/rofi/powermenu.rasi # -theme-str 'mainbox {children: [ "message", "listview" ];}' \
  # -theme-str 'listview {columns: 2; lines: 1;}' \
  # -theme-str 'element-text {horizontal-align: 0.5;}' \
  # -theme-str 'textbox {horizontal-align: 0.5;}' \
  # -theme-str 'inputbar {children: [prompt, textbox-prompt-colon, entry];}' \
  # -theme-str 'textbox-prompt-colon {str: "";}' \
  # -theme-str 'entry {enabled: false;}' \
  # -theme-str 'listview {border: 0px;}' \

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
      sleep 2
      poweroff
    elif [[ $1 == '--reboot' ]]; then
      sleep 2
      reboot
    elif [[ $1 == '--suspend' ]]; then
      sleep 2
      mpc -q pause
      amixer set Master mute
      systemctl suspend
    elif [[ $1 == '--logout' ]]; then
      sleep 2
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

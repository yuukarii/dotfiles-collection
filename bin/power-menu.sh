#!/usr/bin/env bash
# Current Theme
# theme="$HOME/.config/rofi/powermenu.rasi"
theme="$HOME/.config/rofi/powermenu.rasi"

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
  rofi -theme $theme -dmenu -p 'Power'
}

# Confirmation CMD
confirm_cmd() {
  rofi \
    -dmenu \
    -p 'Confirm' \
    -mesg 'Are you Sure?' \
    -theme $theme
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

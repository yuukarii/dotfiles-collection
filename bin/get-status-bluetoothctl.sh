#!/bin/sh

bluetooth_print() {
  # bluetoothctl | grep --line-buffered 'Device\|#' | while read -r REPLY; do
  if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then
    # echo -n ""

    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    counter=0

    for device in $devices_paired; do
      device_info=$(bluetoothctl info "$device")

      if echo "$device_info" | grep -q "Connected: yes"; then
        device_output=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)
        device_battery_percent=$(echo "$device_info" | grep "Battery Percentage" | awk -F'[()]' '{print $2}')

        if [ -n "$device_battery_percent" ]; then
          if [ $device_battery_percent -lt 11 ]; then
            device_battery_icon="󰤾"
          elif [ $device_battery_percent -lt 31 ]; then
            device_battery_icon="󰥀"
          elif [ $device_battery_percent -lt 51 ]; then
            device_battery_icon="󰥂"
          elif [ $device_battery_percent -lt 71 ]; then
            device_battery_icon="󰥄"
          else
            device_battery_icon="󰥈"
          fi

          # device_output="$device_output $device_battery_icon $device_battery_percent%"
          device_output="$device_battery_icon %{F#585b70}${device_battery_percent}%%{F-}"
        fi

        if [ $counter -gt 0 ]; then
          printf ", %s" "$device_output"
        else
          printf "%s" "$device_output"
        fi

        counter=$((counter + 1))
      fi
    done

    printf ' \n'
  else
    echo "#2"
  fi
  # done
}

bluetooth_toggle() {
  if bluetoothctl show | grep -q "Powered: no"; then
    bluetoothctl power on >>/dev/null
    sleep 1

    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    echo "$devices_paired" | while read -r line; do
      bluetoothctl connect "$line" >>/dev/null
    done
  else
    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    echo "$devices_paired" | while read -r line; do
      bluetoothctl disconnect "$line" >>/dev/null
    done

    bluetoothctl power off >>/dev/null
  fi
}

case "$1" in
--toggle)
  bluetooth_toggle
  ;;
*)
  bluetooth_print
  ;;
esac

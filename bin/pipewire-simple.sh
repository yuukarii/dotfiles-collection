#!/bin/sh

getDefaultSink() {
  defaultSink=$(pactl info | awk -F : '/Default Sink:/{print $2}')
  description=$(pactl list sinks | sed -n "/${defaultSink}/,/Description/s/^\s*Description: \(.*\)/\1/p")
  #    echo "${description}"
}

getDefaultSource() {
  defaultSource=$(pactl info | awk -F : '/Default Source:/{print $2}')
  description=$(pactl list sources | sed -n "/${defaultSource}/,/Description/s/^\s*Description: \(.*\)/\1/p")
  echo "${description}"
}

VOLUME=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)
MSG_TAG="myvolume"
#SINK=$(getDefaultSink)
#SOURCE=$(getDefaultSource)

case $1 in
"--up")
  if [ $VOLUME -lt 90 ]; then
    pamixer --increase 2
  fi
  VOLUME=$(pamixer --get-volume)
  dunstify -a "changeVolume" -t 1000 -u low -h string:x-dunst-stack-tag:$MSG_TAG \
    -h int:value:"$VOLUME" "Volume: ${VOLUME}%"
  ;;
"--down")
  if [ $VOLUME -gt 0 ]; then
    pamixer --decrease 2
  fi
  VOLUME=$(pamixer --get-volume)
  dunstify -a "changeVolume" -t 1000 -u low -h string:x-dunst-stack-tag:$MSG_TAG \
    -h int:value:"$VOLUME" "Volume: ${VOLUME}%"
  ;;
"--mute")
  pamixer --toggle-mute
  MUTED=$(pamixer --get-mute)
  if [ "$MUTED" = "true" ]; then
    dunstify -a "changeVolume" -t 1000 -u low -h string:x-dunst-stack-tag:$MSG_TAG "Volume muted"
  fi
  ;;
*)
  #echo "Source: ${SOURCE} | Sink: ${VOLUME} ${SINK}"
  if [ "$MUTED" = "true" ]; then
    echo -e "   %{F#504945}MUTED%{F-}"
  else
    echo -e "   %{F#504945}${VOLUME}%%{F-}"
  fi
  ;;
esac

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
#SINK=$(getDefaultSink)
#SOURCE=$(getDefaultSource)

case $1 in
    "--up")
        if [ $VOLUME -lt 90 ]; then 
	    pamixer --increase 5 
	fi
        ;;
    "--down")
        if [ $VOLUME -gt 0 ]; then 
	    pamixer --decrease 5 
	fi
        ;;
    "--mute")
        pamixer --toggle-mute
        ;;
    *)
        #echo "Source: ${SOURCE} | Sink: ${VOLUME} ${SINK}"
	if [ "$MUTED" = "true" ]; then
	    echo -e " %{F#474747}VOL%{F-} MUTED"
	else
	    echo -e " %{F#474747}VOL%{F-} ${VOLUME}%"
	fi
esac

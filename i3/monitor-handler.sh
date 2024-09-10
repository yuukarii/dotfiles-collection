#!/bin/bash

# Function to get connected outputs
get_connected_outputs() {
    xrandr | grep " connected" | awk '{print $1}'
}

# Function to configure monitors
configure_monitors() {
    connected_outputs=$(get_connected_outputs)
    primary_output=$(echo "$connected_outputs" | head -n 1)

    xrandr --auto  # Reset to default configuration

    if [ $(echo "$connected_outputs" | wc -l) -gt 1 ]; then
        # Multiple monitors connected
        # xrandr --output "$primary_output" --primary
        xrandr --output "$primary_output" --off
        for output in $connected_outputs; do
            if [ "$output" != "$primary_output" ]; then
                xrandr --output "$output" --auto
            fi
        done
    else
        # Single monitor
        xrandr --output "$primary_output" --primary
    fi
}

# Run configuration
configure_monitors

# Restart i3 to apply changes
i3-msg restart
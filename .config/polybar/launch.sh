#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bars
echo "---" | tee -a /tmp/polybar_top.log
polybar top 2>&1 | tee -a /tmp/polybar_top.log & disown

echo "Bars launched"

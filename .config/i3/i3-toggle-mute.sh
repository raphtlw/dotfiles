#!/bin/sh

pactl set-source-mute @DEFAULT_SOURCE@ toggle
dunstify "Mic $(pactl get-source-mute @DEFAULT_SOURCE@)"

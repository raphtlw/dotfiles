#!/bin/sh

touchpad_device_name="ELAN1201:00 04F3:3098 Touchpad"

if xinput --list-props "$touchpad_device_name" | grep -q 'Device Enabled.*1$'; then
  xinput disable "$touchpad_device_name"
  dunstify "Touchpad disabled"
else
  xinput enable "$touchpad_device_name"
  dunstify "Touchpad enabled"
fi

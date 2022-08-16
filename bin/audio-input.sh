#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Audio Input
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎤
# @raycast.packageName Toggle Mic

# Documentation:
# @raycast.description Setup programs for audio input
# @raycast.author Raphael Tang
# @raycast.authorURL https://raph.codes

close() {
  killall obs
  osascript -e 'quit app "micSwitch"'
  osascript -e 'quit app "Mechvibes"'
  pkill -i mechvibes
  pkill -i mechvibes

  exit 0
}

# Check if any of those apps are running
pgrep 'obs|micSwitch|Mechvibes' > /dev/null 2>&1 && close

# Start OBS
pgrep obs > /dev/null 2>&1 || {
  open -a OBS --args --collection Audio --profile General --minimize-to-tray
}
# Start micSwitch
pgrep micSwitch > /dev/null 2>&1 || {
  open -a micSwitch
}
# Start Mechvibes
# pgrep Mechvibes > /dev/null 2>&1 || {
#   open -a Mechvibes
#   osascript -e 'quit app "Mechvibes"'
# }


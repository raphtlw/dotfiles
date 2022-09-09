#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Remove Yellow Dot
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🟡
# @raycast.packageName Utilities

# Documentation:
# @raycast.description Reset microphone indicator on the top right corner
# @raycast.author Raphael Tang
# @raycast.authorURL https://raph.codes

gsudo() {
  osascript -e "do shell script \"$1\" with administrator privileges"
}

gsudo "killall coreaudiod" || exit 1

echo "Done"

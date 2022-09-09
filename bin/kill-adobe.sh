#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kill Adobe
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧹
# @raycast.packageName Utilities

# Documentation:
# @raycast.description Kill all Adobe-related processes
# @raycast.author Raphael Tang
# @raycast.authorURL https://raph.codes

pkill -fi adobe -9

echo "All Adobe-related processes killed ✨"

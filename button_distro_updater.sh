#!/usr/bin/env bash

# Get password via YAD
PASSWORD=$(yad --entry --hide-text --title="Sudo Password" --text="Enter your sudo password:" --button="OK:0" --button="Cancel:1" --center)

# Check if user clicked OK (exit code 0) or Cancel (exit code 1)
if [ $? -eq 0 ]; then
  # Create a named pipe for progress output
  PIPE=$(mktemp -u)
  mkfifo "$PIPE"

  # Function to update progress
  update_progress() {
    echo "$1"
    echo "# $2"
  }

  # Run the upgrade commands with the password
  (
    update_progress 10 "Updating package lists..."
    echo "$PASSWORD" | sudo -S apt-get update >"$PIPE" 2>&1
    update_progress 50 "Upgrading packages..."
    echo "$PASSWORD" | sudo -S apt-get upgrade -y >>"$PIPE" 2>&1
    update_progress 100 "Upgrade complete."
  ) | yad --progress --title="System Update" --text="Starting..." --percentage=0 --auto-close --width=300 --pulsate &

  # Display command output in a larger text-info dialog
  tail -f "$PIPE" | yad --text-info --title="Update Output" --width=700 --height=500

  # Clean up
  rm "$PIPE"
else
  echo "Operation cancelled"
  sleep 2
fi

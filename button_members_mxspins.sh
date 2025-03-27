#!/usr/bin/env bash

# Variables
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Select Your Spin</span>\n\n\n" \
  --field="🚀      Rocket/Dev Spin":FBTN "bash -c 'echo test'" \
  --field="💣     Doomsday/Health Spin":FBTN "bash -c 'echo test'" \
  --field="🎮     Gaming/Pirate Spin":FBTN "bash -c 'echo test'" \
  --field="🧠     Kids/Student Spin":FBTN "bash -c 'echo test'" \
  --field="📚     Parents/Teacher Spin":FBTN "bash -c 'echo test'" \
  --field="🖼️     Assets":FBTN "bash -c '$DOWNLOAD_PATH/button_members_mxspins_assets.sh'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

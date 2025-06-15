#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Members Menu</span>\n\n\n" \
  --field="🌪️     MX-Spins":FBTN "bash -c '$DOWNLOAD_PATH/button_members_mxspins.sh'" \
  --field="🌐     Websites":FBTN "bash -c '$DOWNLOAD_PATH/button_members_websites.sh'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

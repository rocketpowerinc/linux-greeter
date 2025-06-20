#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

INSTALL_REFIND=$(sudo apt install refind
)

# Display the main menu
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Favorite Websites Menu</span>\n\n\n" \
  --field="🏴‍☠️     Pirating":FBTN "bash -c \"$INSTALL_REFIND\"" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?
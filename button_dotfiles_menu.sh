#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Display the main menu with buttons in the center of the fram
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Dotfiles Menu</span>\n\n\n" \
  --field="🌪️     View Dotfiles":FBTN "bash -c '$DOWNLOAD_PATH/button_dotfiles_open.sh'" \
  --field="🚧     Copy Bash Dotfiles":FBTN "bash -c 'echo test'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

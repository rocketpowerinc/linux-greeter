#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Define function to install refind
install_refind() {
  sudo apt update
  sudo apt install -y refind
}

# Export the function so yad can call it
export -f install_refind

# Display the main menu
yad --title="Installer Menu" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Installer Menu</span>\n\n\n" \
  --field="📥  Install rEFInd":FBTN "bash -c install_refind" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

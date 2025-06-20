#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"
############################################################################
# Define function to install refind
install_refind() {
  sudo apt update
  sudo apt install -y refind
}

# Export the function so yad can call it
export -f install_refind

##########################################################################
install_refind_matrix_theme() {

  THEME_DIR="/boot/efi/EFI/refind/themes/Matrix-rEFInd"

  if [ -d "$THEME_DIR" ]; then
    # Print message in green using ANSI escape sequences
    echo -e "\033[0;32mTheme already exists\033[0m"
    read -p "Press Enter to exit..."
    exit 0
  fi

  # Make sure the destination path exists
  sudo mkdir -p /boot/efi/EFI/refind/themes

  # Clone the Matrix-rEFInd theme into the proper folder
  sudo git clone https://github.com/Yannis4444/Matrix-rEFInd.git "$THEME_DIR"

}

# Export the function so yad can call it
export -f install_refind_matrix_theme

#!##############################################################################
# Display the main menu
yad --title="Installer Menu" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Installer Menu</span>\n\n\n" \
  --field="📥  Install rEFInd":FBTN "bash -c $install_refind" \
  --field="📥  Install rEFInd matrix theme":FBTN "bash -c $install_refind_matrix_theme" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

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

################################################################################
install_matrix_theme() {
  local THEME_DIR="/boot/efi/EFI/refind/themes/Matrix-rEFInd"

  if [ -d "$THEME_DIR" ] && [ "$(ls -A "$THEME_DIR")" ]; then
    # Folder exists and is not empty
    echo -e "\e[32mTheme already exists.\e[0m"
    read -p "Press Enter to exit..."
    return 0
  fi

  # Otherwise, create folder and clone
  sudo mkdir -p "$THEME_DIR"
  sudo git clone https://github.com/Yannis4444/Matrix-rEFInd.git "$THEME_DIR"
}
export -f install_matrix_theme


############################################################################
yad --title="Installer Menu" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Installer Menu</span>\n\n\n" \
  --field="📥  Install rEFInd":FBTN "bash -c install_refind" \
  --field="📥  Install rEFInd matrix theme":FBTN "bash -c install_matrix_theme" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

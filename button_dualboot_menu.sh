#!/usr/bin/env bash
#https://refind-themes-collection.netlify.app/

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

############################################################################
# Define function to install refind
install_refind() {
  sudo apt update
  sudo apt install -y refind
  exit
}

# Export the function so yad can call it
export -f install_refind

################################################################################
install_matrix_theme() {
  THEME_DIR="/boot/efi/EFI/refind/themes/Matrix-rEFInd"
  sudo rm -rf "$THEME_DIR"
  sudo mkdir -p "$THEME_DIR"
  sudo git clone https://github.com/Yannis4444/Matrix-rEFInd.git "$THEME_DIR"

  #append the theme configuration to the refind.conf file
  if [ "$(sudo tail -n 1 /boot/efi/EFI/refind/refind.conf)" != "include themes/Matrix-rEFInd/theme.conf" ]; then
    echo "include themes/Matrix-rEFInd/theme.conf" | sudo tee -a /boot/efi/EFI/refind/refind.conf
  fi
  exit
}
export -f install_matrix_theme

################################################################################
install_gruvbox_theme() {
  THEME_DIR="/boot/efi/EFI/refind/themes/refind-gruvbox-theme"
  sudo rm -rf "$THEME_DIR"
  sudo mkdir -p "$THEME_DIR"
  sudo git clone https://github.com/delania-oliveira/refind-gruvbox-theme.git "$THEME_DIR"

  #append the theme configuration to the refind.conf file
  if [ "$(sudo tail -n 1 /boot/efi/EFI/refind/refind.conf)" != "include themes/refind-gruvbox-theme/theme.conf" ]; then
    echo "include themes/refind-gruvbox-theme/theme.conf" | sudo tee -a /boot/efi/EFI/refind/refind.conf
  fi
  exit
}
export -f install_gruvbox_theme


#!##########################################################################
yad --title="Installer Menu" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Installer Menu</span>\n\n\n" \
  --field="📥  Install rEFInd":FBTN "bash -c install_refind" \
  --field="📥  Install rEFInd matrix theme":FBTN "bash -c install_matrix_theme" \
  --field="📥  Install rEFInd gruvbox theme":FBTN "bash -c install_gruvbox_theme" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

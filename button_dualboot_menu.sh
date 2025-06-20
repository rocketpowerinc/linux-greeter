#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

############################################################################
# Define function to install refind
install_refind() {
  sudo apt update
  sudo apt install -y refind
}
export -f install_refind

# Write the theme install script to a file
cat >/tmp/install_matrix_theme.sh <<'EOF'
THEME_DIR="/boot/efi/EFI/refind/themes/Matrix-rEFInd"
if [ -d "$THEME_DIR" ] && [ "$(ls -A "$THEME_DIR")" ]; then
  echo -e "\033[0;32mTheme already exists\033[0m"
  read -p "Press Enter to exit..."
  exit 0
fi
sudo mkdir -p /boot/efi/EFI/refind/themes
sudo git clone https://github.com/Yannis4444/Matrix-rEFInd.git "$THEME_DIR"
EOF
chmod +x /tmp/install_matrix_theme.sh

############################################################################
yad --title="Installer Menu" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Installer Menu</span>\n\n\n" \
  --field="📥  Install rEFInd":FBTN "bash -c install_refind" \
  --field="📥  Install rEFInd matrix theme":FBTN "bash /tmp/install_matrix_theme.sh" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

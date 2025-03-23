#!/usr/bin/env bash

# Ensure the required packages are installed (sudo will prompt for a password)
# Uncomment the following lines if you want to install them automatically
# sudo apt install zenity -y
# sudo apt install yad -y
# sudo apt install git -y
# sudo apt install flatpak -y
# sudo apt install fonts-noto-color-emoji -y

# Set Dark Mode theme
export GTK_THEME=Adwaita:dark

# Disable history expansion to prevent errors
set +H

# Define repository URL and download path
REPO_URL="https://github.com/rocketpowerinc/linux-greeter.git"
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Clean up any previous clones
rm -rf "$DOWNLOAD_PATH"

# Clone the repository
if ! git clone "$REPO_URL" "$DOWNLOAD_PATH"; then
  yad --error --text="Failed to clone the repository."
  exit 1
fi

# Make all shell scripts executable
find "$DOWNLOAD_PATH" -type f -name "*.sh" -exec chmod +x {} \;

# Display the main menu with buttons in the center of the fram
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large' foreground='gold'>🚀⚡ Welcome to the Power Greeter ⚡🚀</span>\n
<span size='x-large' foreground='green'>Linux Edition</span>\n\n\n" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF269')</span>     ReadMe":FBTN "bash -c '$DOWNLOAD_PATH/button_open_website.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Manage apt pkgs":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_apt.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Manage Flatpaks":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_flatpak.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Manage Nix pkgs":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_nix.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF1D3')</span>     Titus LinUtil":FBTN "bash -c '$DOWNLOAD_PATH/button_open_tituslinutil.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF17C')</span>     Distro Specific":FBTN "bash -c '$DOWNLOAD_PATH/button_distro_menu.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uE70C')</span>     ScriptBin":FBTN "bash -c '$DOWNLOAD_PATH/button_open_scriptbin.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF308')</span>     Docker":FBTN "bash -c '$DOWNLOAD_PATH/button_docker_menu.sh'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF3A5')</span>     Dotfiles":FBTN "bash -c '$DOWNLOAD_PATH/button_dotfiles_menu.sh'" \
  --field="<span foreground='gold'>$(printf '\uF023')</span>     Members Only":FBTN "bash -c '$DOWNLOAD_PATH/button_members_menu.sh'"

choice=$?

# Clean up by removing the downloaded repository
rm -rf "$DOWNLOAD_PATH"

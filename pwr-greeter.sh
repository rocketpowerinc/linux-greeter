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

# Get the current date
current_date=$(date +"%A, %B %d, %Y, %I:%M %p")

# Display the main menu with buttons in the center of the frame
yad --title="Rocket Power Included" \
    --width=600 --height=600 \
    --form --columns=2 --align=center --no-buttons --dark \
    --text-align=center --text="<span size='x-large' foreground='gold'>🚀⚡ Welcome to the Power Greeter ⚡🚀</span>\n
            <span size='medium' foreground='white'>$current_date</span>\n\n\n" \
    --field="📦 Package Manager - APT":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_apt.sh'" \
    --field="📦 Package Manager - Flatpak":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_flatpak.sh'" \
    --field="📦 Package Manager - Nix":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_nix.sh'" \
    --field="🗑️ Script Bin":FBTN "bash -c '$DOWNLOAD_PATH/button_open_scriptbin.sh'"

choice=$?

# Trigger the corresponding action based on the button pressed
case $choice in
    1) bash "$DOWNLOAD_PATH/button_packages_apt.sh" ;;
    2) bash "$DOWNLOAD_PATH/button_packages_flatpak.sh" ;;
    3) bash "$DOWNLOAD_PATH/button_packages_nix.sh" ;;
    4) bash "$DOWNLOAD_PATH/button_open_scriptbin.sh" ;;
esac

# Clean up by removing the downloaded repository
rm -rf "$DOWNLOAD_PATH"


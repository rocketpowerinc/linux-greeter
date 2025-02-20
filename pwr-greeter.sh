#!/usr/bin/env bash

#todo - Make sure the following packages are installed (not here beacause sudo will ask for passsword)
#sudo apt install zenity -y
#sudo apt install git -y
#sudo apt install flatpak -y
#sudo apt install fonts-noto-color-emoji -y

# Clone the repository into $HOME/Downloads
REPO_URL="https://github.com/rocketpowerinc/linux-greeter.git"
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Clean up
rm -rf "$DOWNLOAD_PATH"

# Clone repo
git clone "$REPO_URL" "$DOWNLOAD_PATH"

# chmod +x
find $DOWNLOAD_PATH -type f -name "*.sh" -exec chmod +x {} \;

# Check if the clone was successful
if [ $? -ne 0 ]; then
    zenity --error --text="Failed to clone the repository."
    exit 1
fi

# Present a list of options to the user
CHOICE=$(zenity --list --title="Choose a script to run" --column="Scripts" \
    "📦 Package Manager - APT" \
    "📦 Package Manager - Flatpak" \
    "📦 Package Manager - Nix" \
    "🗑️ Script Bin" \
    --width=500 --height=500)

# Check the user's choice
case "$CHOICE" in
    "📦 Package Manager - APT")
        bash "$DOWNLOAD_PATH/button_packages_apt.sh"
        ;;
    "📦 Package Manager - Flatpak")
        bash "$DOWNLOAD_PATH/button_packages_flatpak.sh"
        ;;
    "📦 Package Manager - Nix")
        bash "$DOWNLOAD_PATH/button_packages_nix.sh"
        ;;
    "🗑️ Script Bin")
        bash "$DOWNLOAD_PATH/button_open_scriptbin.sh"
        ;;
    *)
        # If the user closes the dialog or cancels, show a Cancel dialog
        #zenity --info --text="Canceled by user." #*this was annoying
        exit 0
        ;;
esac

# Clean up
rm -rf "$DOWNLOAD_PATH"

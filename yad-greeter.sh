#!/usr/bin/env bash

#todo - Make sure the following packages are installed (not here beacause sudo will ask for passsword)
#sudo apt install zenity -y
#sudo apt install yad -y
#sudo apt install git -y
#sudo apt install flatpak -y
#sudo apt install fonts-noto-color-emoji -y


#Dark Mode
export GTK_THEME=Adwaita:dark

# Disable history expansion - will get a bash error without this
set +H

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
    yad --error --text="Failed to clone the repository."
    exit 1
fi

# Display the main menu with buttons in the middle of the frame
yad --title="Yad Showcase" \
    --width=600 --height=600 \
    --form --columns=2 --align=center --no-buttons --dark \
    --text="<span size='x-large' foreground='gold'>✨ Welcome to the Yad Showcase ✨</span>\n
            <span size='large' foreground='lightblue'>Experience the magic of Yad with flair and dark mode!</span>\n\n\n" \
    --field="📦 Package Manager - APT":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_apt.sh'" \
    --field="📦 Package Manager - Flatpak":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_flatpak.sh'" \
    --field="📦 Package Manager - Nix":FBTN "bash -c '$DOWNLOAD_PATH/button_packages_nix.sh'" \
    --field="🗑️ Script Bin":FBTN "bash -c '$DOWNLOAD_PATH/button_open_scriptbin.sh'"

choice=$?

# Trigger the corresponding action based on the button pressed
case $choice in
    1)
        bash "$DOWNLOAD_PATH/button_packages_apt.sh" ;;
    2)
        bash "$DOWNLOAD_PATH/button_packages_flatpak.sh" ;;
    3)
        bash "$DOWNLOAD_PATH/button_packages_nix.sh" ;;
    4)
        bash "$DOWNLOAD_PATH/button_open_scriptbin.sh" ;;
esac

# Clean up
rm -rf "$DOWNLOAD_PATH"

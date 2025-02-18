#!/usr/bin/env bash

# Clone the repository into $HOME/Downloads
REPO_URL="https://github.com/rocketpowerinc/linux-greeter.git"
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Clean up
rm -rf "$DOWNLOAD_PATH"

# Clone repo
git clone "$REPO_URL" "$DOWNLOAD_PATH"

# Check if the clone was successful
if [ $? -ne 0 ]; then
    zenity --error --text="Failed to clone the repository."
    exit 1
fi

# Create the Zenity dialog with a list of options
CHOICE=$(zenity --list --radiolist --title="Choose a script to run" --column="Select" --column="Script" TRUE "APT Script" FALSE "Flatpak Script")

# Check the user's choice
if [ "$CHOICE" = "APT Script" ]; then
    # Run button_packages_apt.sh
    bash "$DOWNLOAD_PATH/button_packages_apt.sh"
elif [ "$CHOICE" = "Flatpak Script" ]; then
    # Run button_packages_flatpak.sh
    bash "$DOWNLOAD_PATH/button_packages_flatpak.sh"
else
    # If the user closes the dialog, show a goodbye message
    zenity --info --text="Goodbye!"
    exit 0
fi

# Clean up
rm -rf "$DOWNLOAD_PATH"

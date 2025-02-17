#!/usr/bin/env bash

#todo if I uncomment this it looks worse on NixOS (I think because dark mode is already on, so no need for this)
#export GTK_THEME=Adwaita:dark

# Clone repo
git clone https://github.com/rocketpowerinc/appbundles.git $HOME/Downloads/appbundles

# Define the path to the master file
MASTER_FILE="/home/rocket/Downloads/appbundles/Flatpaks/Master.txt"

# Echo the master file path for verification
echo "Master file path: $MASTER_FILE"

# Check if the file exists
if [[ ! -f $MASTER_FILE ]]; then
    zenity --error --text="Master file not found at $MASTER_FILE" --width=500 --height=200
    exit 1
fi

# Print the contents of the master file for debugging
echo "Contents of master file:"
cat "$MASTER_FILE"

# Get installed Flatpak applications
INSTALLED_APPS=$(flatpak list --app --columns=application)
echo "Installed applications:"
echo "$INSTALLED_APPS"

# Manually add 'org.deskflow.deskflow' to installed applications for testing
INSTALLED_APPS+=$'\norg.deskflow.deskflow'

# Read the list and format it for Zenity, marking installed apps as checked
APP_LIST=""
while IFS= read -r LINE || [[ -n "$LINE" ]]; do
    # Skip comment lines and empty lines
    if [[ "$LINE" =~ ^# ]] || [[ -z "$LINE" ]]; then
        continue
    fi
    CATEGORY=$(echo "$LINE" | cut -d'|' -f1)
    APP=$(echo "$LINE" | cut -d'|' -f2)
    echo "Processing $APP in category $CATEGORY"
    if echo "$INSTALLED_APPS" | grep -q "^$APP$"; then
        APP_LIST+=" TRUE \"$APP\" \"$CATEGORY\""
    else
        APP_LIST+=" FALSE \"$APP\" \"$CATEGORY\""
    fi
done < "$MASTER_FILE"

echo "Application list for Zenity: $APP_LIST"

# Ask the user to select applications
SELECTION=$(zenity --list --checklist --title="Flatpak Manager" --text="Select applications to install/uninstall:" \
    --column="Select" --column="Application" --column="Category" $APP_LIST --separator=" " --width=800 --height=600)

# Refresh installed apps list after selection
INSTALLED_APPS=$(flatpak list --app --columns=application)

# Process uninstallation of unchecked apps
for APP in $INSTALLED_APPS; do
    if [[ ! " $SELECTION " =~ " $APP " ]]; then
        flatpak uninstall -y "$APP" | zenity --progress --title="Uninstalling $APP" --text="Uninstalling..." --pulsate --auto-close --width=500 --height=200
    fi
done

# Process installation of selected apps
if [[ -n "$SELECTION" ]]; then
    for APP in $SELECTION; do
        if ! echo "$INSTALLED_APPS" | grep -q "^$APP$"; then
            flatpak install -y "$APP" | zenity --progress --title="Installing $APP" --text="Installing..." --pulsate --auto-close --width=500 --height=200
        fi
    done
fi

zenity --info --text="Operation completed." --width=500 --height=200

# Clean Up
rm -rf $HOME/Downloads/appbundles

#!/usr/bin/env bash

#todo if I uncoment this it looks worst on nixos (I think because dark mode is already on so no need for this)
#export GTK_THEME=Adwaita:dark


# Download the list of Flatpak applications
curl -o master.txt https://raw.githubusercontent.com/rocketpowerinc/appbundles/main/Flatpaks/Master.txt

# Check if the file was downloaded successfully
if [[ ! -s master.txt ]]; then
    zenity --error --text="Failed to download application list."
    exit 1
fi

# Get installed Flatpak applications
INSTALLED_APPS=$(flatpak list --app --columns=application)

# Read the list and format it for Zenity, marking installed apps as checked
APP_LIST=""
while read -r APP; do
    if echo "$INSTALLED_APPS" | grep -q "^$APP$"; then
        APP_LIST+="TRUE $APP "
    else
        APP_LIST+="FALSE $APP "
    fi
done < master.txt

# Ask the user to select applications
SELECTION=$(zenity --list --checklist --title="Flatpak Manager" --text="Select applications to install/uninstall:" \
    --column="Select" --column="Application" $APP_LIST --separator=" ")

# Refresh installed apps list after selection
INSTALLED_APPS=$(flatpak list --app --columns=application)

# Process uninstallation of unchecked apps
for APP in $INSTALLED_APPS; do
    if [[ ! " $SELECTION " =~ " $APP " ]]; then
        flatpak uninstall -y "$APP" | zenity --progress --title="Uninstalling $APP" --text="Uninstalling..." --pulsate --auto-close
    fi
done

# Process installation of selected apps
if [[ -n "$SELECTION" ]]; then
    for APP in $SELECTION; do
        if ! echo "$INSTALLED_APPS" | grep -q "^$APP$"; then
            flatpak install -y "$APP" | zenity --progress --title="Installing $APP" --text="Installing..." --pulsate --auto-close
        fi
    done
fi

zenity --info --text="Operation completed."

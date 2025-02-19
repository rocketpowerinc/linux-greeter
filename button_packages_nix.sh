#!/usr/bin/env bash

# Define the repository URL and the download path
REPO_URL="https://github.com/rocketpowerinc/appbundles.git"
DOWNLOAD_PATH="$HOME/Downloads/appbundles"
MASTER_FILE="$DOWNLOAD_PATH/NIX/Master.txt"

# Clean up
rm -rf "$DOWNLOAD_PATH"

# Function to display an error message and exit
show_error() {
  echo "$1" >&2
  zenity --error --text="$1" --width=500 --height=200
  exit 1
}

# Clone the repository
git clone "$REPO_URL" "$DOWNLOAD_PATH" || show_error "Failed to clone the repository."

# Verify the master file exists
[[ -f "$MASTER_FILE" ]] || show_error "Master file not found at $MASTER_FILE"

# Get installed Nix packages and strip the prefix
INSTALLED_APPS=$(nix profile list | awk '{print $3}' | sed -e 's/^legacyPackages\.x86_64-linux\.//' -e 's/^nixpkgs#//')

# Generate the application list for Zenity
INSTALLED_LIST=()
AVAILABLE_LIST=()
while IFS='|' read -r CATEGORY APP; do
  # Skip comment lines and empty lines
  if [[ "$CATEGORY" =~ ^# ]] || [[ -z "$CATEGORY" ]]; then
    continue
  fi
  if echo "$INSTALLED_APPS" | grep -q "^$APP$"; then
    INSTALLED_LIST+=("TRUE" "$APP" "$CATEGORY")
  else
    AVAILABLE_LIST+=("FALSE" "$APP" "$CATEGORY")
  fi
done <"$MASTER_FILE"

# Display installed apps selection dialog
UNINSTALL_SELECTION=$(zenity --list --checklist --title="Nix Manager - Uninstall" --text="Select applications to uninstall:" \
  --column="Select" --column="Application" --column="Category" "${INSTALLED_LIST[@]}" --separator="|" --width=800 --height=600)

# Display available apps selection dialog
INSTALL_SELECTION=$(zenity --list --checklist --title="Nix Manager - Install" --text="Select applications to install:" \
  --column="Select" --column="Application" --column="Category" "${AVAILABLE_LIST[@]}" --separator="|" --width=800 --height=600)

# Convert SELECTION into arrays
IFS='|' read -r -a UNSELECTED_APPS <<< "$UNINSTALL_SELECTION"
IFS='|' read -r -a SELECTED_APPS <<< "$INSTALL_SELECTION"

# Debugging: Print selected and unselected apps
echo "Selected apps: ${SELECTED_APPS[@]}"
echo "Unselected apps: ${UNSELECTED_APPS[@]}"

# Process uninstallation of unchecked apps
for APP in "${UNSELECTED_APPS[@]}"; do
  echo "Uninstalling $APP"
  zenity --info --text="Uninstalling $APP" --width=500 --height=200
  (nix profile remove $APP | tee >(zenity --progress --title="Uninstalling $APP" --text="Uninstalling..." --pulsate --auto-close --width=500 --height=200)) || show_error "Error uninstalling $APP"
done

# Process installation of selected apps
for APP in "${SELECTED_APPS[@]}"; do
  echo "Installing $APP"
  zenity --info --text="Installing $APP" --width=500 --height=200
  (nix profile install "nixpkgs#$APP" | tee >(zenity --progress --title="Installing $APP" --text="Installing..." --pulsate --auto-close --width=500 --height=200)) || show_error "Error installing $APP"
done

zenity --info --text="Operation completed." --width=500 --height=200

# Clean up
rm -rf "$DOWNLOAD_PATH"

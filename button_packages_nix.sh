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
APP_LIST=()
MASTER_APPS=()
while IFS='|' read -r CATEGORY APP; do
  # Skip comment lines and empty lines
  if [[ "$CATEGORY" =~ ^# ]] || [[ -z "$CATEGORY" ]]; then
    continue
  fi
  SELECTED=$(echo "$INSTALLED_APPS" | grep -q "^$APP$" && echo TRUE || echo FALSE)
  APP_LIST+=("$SELECTED" "$APP" "$CATEGORY")
  MASTER_APPS+=("$APP")
done <"$MASTER_FILE"

# Function to update the checklist
update_checklist() {
  local selected_all=$1
  APP_LIST=()
  while IFS='|' read -r CATEGORY APP; do
    # Skip comment lines and empty lines
    if [[ "$CATEGORY" =~ ^# ]] || [[ -z "$CATEGORY" ]]; then
      continue
    fi
    SELECTED=$selected_all
    APP_LIST+=("$SELECTED" "$APP" "$CATEGORY")
  done <"$MASTER_FILE"
}

# Initial display of selection dialog
while true; do
  SELECTION=$(zenity --list --checklist --title="Nix Manager" --text="Select applications to install/uninstall:" \
    --column="Select" --column="Application" --column="Category" "${APP_LIST[@]}" \
    --extra-button="Select All" --extra-button="Unselect All" --separator=" " --width=800 --height=600)

  # Handle Select All and Unselect All buttons
  if [[ "$SELECTION" == "Select All" ]]; then
    update_checklist TRUE
  elif [[ "$SELECTION" == "Unselect All" ]]; then
    update_checklist FALSE
  else
    break
  fi
done

# Ensure SELECTION is not empty
if [[ -z "$SELECTION" ]]; then
  zenity --info --text="No applications selected." --width=500 --height=200
  exit 0
fi

# Refresh installed apps list after selection
INSTALLED_APPS=$(nix profile list | awk '{print $3}' | sed -e 's/^legacyPackages\.x86_64-linux\.//' -e 's/^nixpkgs#//')

# Process uninstallation of unchecked apps only if they are in Master.txt
for APP in "${MASTER_APPS[@]}"; do
  if echo "$INSTALLED_APPS" | grep -q "^$APP$" && ! echo "$SELECTION" | grep -q "$APP"; then
    (nix profile remove $APP | tee >(zenity --progress --title="Uninstalling $APP" --text="Uninstalling..." --pulsate --auto-close --width=500 --height=200)) || show_error "Error uninstalling $APP"
  fi
done

# Process installation of selected apps
for APP in $SELECTION; do
  if ! echo "$INSTALLED_APPS" | grep -q "^$APP$"; then
    (nix profile install "nixpkgs#$APP" | tee >(zenity --progress --title="Installing $APP" --text="Installing..." --pulsate --auto-close --width=500 --height=200)) || show_error "Error installing $APP"
  fi
done

zenity --info --text="Operation completed." --width=500 --height=200

# Clean up
rm -rf "$DOWNLOAD_PATH"

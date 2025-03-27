#!/usr/bin/env bash

# Define the repository URL and the download path
REPO_URL="https://github.com/rocketpowerinc/assets.git"
DOWNLOAD_PATH="$HOME/Downloads/assets"

# Clean up any previous attempts
rm -rf "$DOWNLOAD_PATH"

# Function to show progress bar
show_progress() {
  yad --progress \
    --title "Downloading Assets" \
    --text "Cloning repository..." \
    --percentage 0 \
    --pulsate \
    --auto-close \
    --width 400 --height 100 # Make progress bar bigger
}

# Function to close progress bar
close_progress() {
  pkill -x "yad --progress"
}

# Show progress bar
show_progress &
PROGRESS_PID=$!

# Clone the repository
git clone "$REPO_URL" "$DOWNLOAD_PATH" || {
  echo "Failed to clone the repository."
  close_progress
  exit 1
}

# Close progress bar
close_progress

# Wallpaper directory selection
WALLPAPER_CHOICES=(
  "Spin-DoomsdayPrepper"
  "Spin-GamingPirate"
  "Spin-KidsStudent"
  "Spin-ParentTeacher"
  "Spin-RocketDev"
)

WALLPAPER_PATHS=(
  "$DOWNLOAD_PATH/wallpapers/Spin-DoomsdayPrepper"
  "$DOWNLOAD_PATH/wallpapers/Spin-GamingPirate"
  "$DOWNLOAD_PATH/wallpapers/Spin-KidsStudent"
  "$DOWNLOAD_PATH/wallpapers/Spin-ParentTeacher"
  "$DOWNLOAD_PATH/wallpapers/Spin-RocketDev"
)

# Create yad options
YAD_OPTIONS=$(printf "%s\n" "${WALLPAPER_CHOICES[@]}")

SELECTED_WALLPAPER=$(
  yad --list \
    --radiolist \
    --title "Select Wallpaper Category" \
    --text "Choose which wallpaper category to install:" \
    --column "Select" --column "Category" \
    --width 600 --height 400 # Make the list wider and taller
  "FALSE" "${WALLPAPER_CHOICES[0]}" \
    "FALSE" "${WALLPAPER_CHOICES[1]}" \
    "FALSE" "${WALLPAPER_CHOICES[2]}" \
    "FALSE" "${WALLPAPER_CHOICES[3]}" \
    "FALSE" "${WALLPAPER_CHOICES[4]}"
)

# Validate selection and extract index.  If the user cancels, $SELECTED_WALLPAPER will be empty
if [[ -n "$SELECTED_WALLPAPER" ]]; then
  # Determine the index of the selected wallpaper
  SELECTED_INDEX=$(printf '%s\n' "${WALLPAPER_CHOICES[@]}" | grep -n -m 1 -w "$SELECTED_WALLPAPER" | cut -d ':' -f 1)

  # Subtract 1 to convert from grep's 1-based indexing to bash's 0-based indexing
  SELECTED_INDEX=$((SELECTED_INDEX - 1))

  # Get the wallpaper path.
  SELECTED_WALLPAPER_PATH="${WALLPAPER_PATHS[$SELECTED_INDEX]}"

  # Install Wallpapers

  # First, delete all files and folders inside /usr/share/backgrounds/
  sudo rm -rf /usr/share/backgrounds/*

  sudo mkdir -p /usr/share/backgrounds
  sudo find "$SELECTED_WALLPAPER_PATH" -type f -exec mv {} /usr/share/backgrounds/ \;
else
  echo "Wallpaper installation cancelled."
fi

# Icons
sudo mkdir -p /usr/share/icons
sudo find "$DOWNLOAD_PATH/icons/" -type f -exec mv {} /usr/share/icons/ \;

# Clean up
rm -rf "$DOWNLOAD_PATH"

echo "Done."

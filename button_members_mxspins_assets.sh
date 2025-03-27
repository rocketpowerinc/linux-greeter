#!/usr/bin/env bash

# Define repository and download path
REPO_URL="https://github.com/rocketpowerinc/assets.git"
DOWNLOAD_PATH="$HOME/Downloads/assets"

# Clean up any previous attempts
rm -rf "$DOWNLOAD_PATH"

# Function to show progress bar with actual updates
show_progress() {
  (
    echo "5" # Small delay before start
    echo "# Initializing clone..."
    git clone "$REPO_URL" "$DOWNLOAD_PATH" 2>&1 | while read -r line; do
      echo "# $line" # Show git output as message
      echo "50"      # Approximate midway point (git doesn't report exact %)
    done
    echo "100" # Completion
  ) | yad --progress \
    --title "Downloading Assets" \
    --text "Cloning repository..." \
    --percentage 0 \
    --auto-close \
    --auto-kill \
    --width 400 --height 100
}

# Show progress and clone repository
show_progress || {
  echo "Failed to clone the repository."
  exit 1
}

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
SELECTED_WALLPAPER=$(
  yad --list \
    --radiolist \
    --title "Select Wallpaper Category" \
    --text "Choose which wallpaper category to install:" \
    --column "Select" --column "Category" \
    --width 600 --height 400 \
    "FALSE" "${WALLPAPER_CHOICES[0]}" \
    "FALSE" "${WALLPAPER_CHOICES[1]}" \
    "FALSE" "${WALLPAPER_CHOICES[2]}" \
    "FALSE" "${WALLPAPER_CHOICES[3]}" \
    "FALSE" "${WALLPAPER_CHOICES[4]}"
)

# Validate selection and extract index. If the user cancels, $SELECTED_WALLPAPER will be empty
if [[ -n "$SELECTED_WALLPAPER" ]]; then
  # Determine the index of the selected wallpaper
  SELECTED_INDEX=$(printf '%s\n' "${WALLPAPER_CHOICES[@]}" | grep -n -m 1 -w "$SELECTED_WALLPAPER" | cut -d ':' -f 1)
  SELECTED_INDEX=$((SELECTED_INDEX - 1)) # Convert grep's 1-based index to bash 0-based

  # Get the wallpaper path
  SELECTED_WALLPAPER_PATH="${WALLPAPER_PATHS[$SELECTED_INDEX]}"

  # First, delete all files and folders inside /usr/share/backgrounds/
  sudo rm -rf /usr/share/backgrounds/*

  # Install Wallpapers
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

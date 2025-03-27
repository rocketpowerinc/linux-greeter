#!/usr/bin/env bash

# Define repository and download path
REPO_URL="https://github.com/rocketpowerinc/assets.git"
DOWNLOAD_PATH="$HOME/Downloads/assets"

# Clean up any previous attempts
rm -rf "$DOWNLOAD_PATH"

# Function to show progress bar with real-time updates
show_progress() {
  echo "Starting repository clone..."

  # Open a subshell for real-time progress tracking
  (
    echo "5"
    echo "# Initializing clone..."

    # Clone the repository while printing live output
    git clone "$REPO_URL" "$DOWNLOAD_PATH" 2>&1 | while read -r line; do
      echo "$line" >&2 # Print to terminal
      echo "# $line"   # Show in YAD progress bar
      echo "25"        # Increment progress
    done

    echo "50"
    sleep 1 # Small delay for better UI effect

    echo "100"
    echo "# Clone complete."
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
echo "Repository clone completed successfully!"

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
    TRUE "${WALLPAPER_CHOICES[0]}" \
    FALSE "${WALLPAPER_CHOICES[1]}" \
    FALSE "${WALLPAPER_CHOICES[2]}" \
    FALSE "${WALLPAPER_CHOICES[3]}" \
    FALSE "${WALLPAPER_CHOICES[4]}" | awk -F '|' '{print $2}'
)

# Validate selection and extract index
if [[ -n "$SELECTED_WALLPAPER" ]]; then
  # Extract the index correctly
  for i in "${!WALLPAPER_CHOICES[@]}"; do
    if [[ "${WALLPAPER_CHOICES[$i]}" == "$SELECTED_WALLPAPER" ]]; then
      SELECTED_INDEX=$i
      break
    fi
  done

  # Get the correct wallpaper path
  SELECTED_WALLPAPER_PATH="${WALLPAPER_PATHS[$SELECTED_INDEX]}"
  echo "Selected wallpaper category: ${WALLPAPER_CHOICES[$SELECTED_INDEX]}"
  echo "Installing wallpapers from: $SELECTED_WALLPAPER_PATH"

  # First, delete all files and folders inside /usr/share/backgrounds/
  sudo rm -rf /usr/share/backgrounds/*

  # Install Wallpapers
  sudo mkdir -p /usr/share/backgrounds
  sudo cp -r "$SELECTED_WALLPAPER_PATH/"* /usr/share/backgrounds/
else
  echo "Wallpaper installation cancelled."
fi

# Icons
echo "Installing icons..."
sudo mkdir -p /usr/share/icons
sudo cp -r "$DOWNLOAD_PATH/icons/"* /usr/share/icons/

# Clean up
rm -rf "$DOWNLOAD_PATH"
echo "All tasks completed successfully!"

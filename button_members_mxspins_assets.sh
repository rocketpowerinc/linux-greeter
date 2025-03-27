#!/usr/bin/env bash

# Define the repository URL and the download path
REPO_URL="https://github.com/rocketpowerinc/assets.git"
DOWNLOAD_PATH="$HOME/Downloads/assets"

# Clean up any previous attempts
rm -rf "$DOWNLOAD_PATH"

# Clone the repository with progress updates
clone_repo() {
  # Start yad with --text-info
  yad --title "Downloading Assets" --text-info --width 400 --height 100 --no-buttons &
  YAD_PID=$!

  # Get total files to download to estimate the percentage. This is not exact but better than nothing
  TOTAL_FILES=$(git ls-remote "$REPO_URL" | wc -l)
  FILES_DOWNLOADED=0

  # Clone the repo and show progress by updating yad
  git clone "$REPO_URL" "$DOWNLOAD_PATH" 2>&1 | while IFS= read -r line; do
    FILES_DOWNLOADED=$((FILES_DOWNLOADED + 1))
    PERCENTAGE=$(((FILES_DOWNLOADED * 100) / TOTAL_FILES))

    # Update yad's text
    TEXT_TO_SHOW="Downloading.... $PERCENTAGE%"
    echo "$TEXT_TO_SHOW" | yad --title "Downloading Assets" --text-info --width 400 --height 100 --no-buttons --replace --pid "$YAD_PID" --text

  done || {
    echo "Failed to clone the repository."
    kill "$YAD_PID" 2>/dev/null
    exit 1
  }

  # Kill yad after cloning is done
  kill "$YAD_PID" 2>/dev/null
}

# Clone the repository
clone_repo

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

# Validate selection and extract index.  If the user cancels, $SELECTED_WALLPAPER will be empty
if [[ -n "$SELECTED_WALLPAPER" ]]; then
  # Determine the index of the selected wallpaper
  SELECTED_INDEX=$(printf '%s\n' "${WALLPAPER_CHOICES[@]}" | grep -n -m 1 -w "$SELECTED_WALLPAPER" | cut -d ':' -f 1)

  # Subtract 1 to convert from grep's 1-based indexing to bash's 0-based indexing
  SELECTED_INDEX=$((SELECTED_INDEX - 1))

  # Get the wallpaper path.
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

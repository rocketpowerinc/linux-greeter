#!/usr/bin/env bash

# Define repository and download path
REPO_URL="https://github.com/rocketpowerinc/assets.git"
DOWNLOAD_PATH="$HOME/Downloads/assets"

# Clean up any previous attempts
rm -rf "$DOWNLOAD_PATH"

# Function to show progress bar with real-time updates and speed tracking
show_progress() {
  echo "Starting repository clone..."

  (
    echo "5"
    echo "# Initializing clone..."

    # Check if `pv` (Pipe Viewer) is installed
    if command -v pv >/dev/null 2>&1; then
      # Use pv to monitor progress in the background
      PV_PID=0 # Initialize PV_PID
      last_percent=0
      (
        git clone "$REPO_URL" "$DOWNLOAD_PATH" 2>&1 | pv -L 500k -p -t -r -e -n >&2 | while read -r pv_line; do
          SPEED=$(echo "$pv_line" | grep -oE '[0-9.]+ [KM]B/s')
          PERCENT=$(echo "$pv_line" | grep -oE '[0-9]+%' | tr -d '%')

          if [[ "$PERCENT" =~ ^[0-9]+$ ]]; then
              if (( $(echo "$PERCENT > $last_percent" | bc -l) )); then
                  last_percent="$PERCENT"
              fi
          fi
        done
        echo "PV_DONE" >&2 # Signal that pv is finished.  Crucial for progress bar completion.
      ) &
      PV_PID=$!  # Save the process ID of the background pv pipeline

      # Capture git clone output, process progress bar updates
      while read -r line; do
        if [[ "$line" == "PV_DONE" ]]; then
          break # Exit loop if pv pipeline is finished
        fi

        echo "$line" # Print git clone output to terminal
        echo "$last_percent"
        echo "# Cloning repository"
      done < <( tail -f -n 0 <&"$2" ) 2>&1 # Capture output
       wait "$PV_PID" # Wait for pv background process to complete before exiting.
      echo "100"
      echo "# Clone complete."

    else
      #If pv is not installed.
      echo "pv is not installed. Please install it for speed tracking." >&2
      git clone "$REPO_URL" "$DOWNLOAD_PATH"
      echo "100"
      echo "# Clone complete."
    fi
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
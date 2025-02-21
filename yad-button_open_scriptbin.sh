#!/usr/bin/env bash

# Set Dark Mode theme
export GTK_THEME=Adwaita:dark


# Define the repository URL and the download path
REPO_URL="https://github.com/rocketpowerinc/scriptbin.git"
DOWNLOAD_PATH="$HOME/Downloads/scriptbin"

# Clean up any existing directory
rm -rf "$DOWNLOAD_PATH"

# Clone the repository
git clone "$REPO_URL" "$DOWNLOAD_PATH" || { echo "Failed to clone the repository." >&2; exit 1; }

# Copy scripts to ~/.local/bin/
mkdir -p $HOME/.local/bin/ && command cp -rf "$DOWNLOAD_PATH/Linux/"* "$HOME/.local/bin/"


# Temporarily export PATH (add to bashrc to make permanent)
for dir in $HOME/.local/bin/*; do
  if [ -d "$dir" ]; then
    PATH="$dir:$PATH"
  fi
done
export PATH

# Make all scripts executable
find "$HOME/.local/bin/" -type f -exec chmod +x {} \;

# Open file selection dialog using yad
SCRIPT=$(yad --title="Select a Script" --file --filename="$HOME/.local/bin/" --width=800 --height=600)

# Check if a script was selected
if [ -n "$SCRIPT" ]; then
  # Preview the selected script in gnome-text-editor
  gnome-text-editor "$SCRIPT"

  # Ask the user if they want to run the script using yad
  if yad --title="Run Script" --question --text="Do you want to run the selected script?"; then
    # Run the selected script with bash
    bash "$SCRIPT"
  fi
fi

# Clean up
rm -rf "$DOWNLOAD_PATH"

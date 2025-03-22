#!/usr/bin/env bash

# Define the repository URL and the download path
REPO_URL="https://github.com/rocketpowerinc/scriptbin.git"
DOWNLOAD_PATH="$HOME/Downloads/scriptbin"

# Clean up
rm -rf "$DOWNLOAD_PATH"

# Clone the repository
git clone "$REPO_URL" "$DOWNLOAD_PATH" || show_error "Failed to clone the repository."

mkdir -p $HOME/.local/bin/ 
cp -rf $DOWNLOAD_PATH/Linux/* $HOME/.local/bin/
cp -rf $DOWNLOAD_PATH/Cross-Platform-Powershell $HOME/.local/bin/


#* Temporarily export PATH (add to bashrc to make permanent)
for dir in $HOME/.local/bin/*; do
  if [ -d "$dir" ]; then
    PATH="$dir:$PATH"
  fi
done
export PATH

#*make all executable
find $HOME/.local/bin/ -type f -exec chmod +x {} \;


# Open file selection dialog
SCRIPT=$(zenity --file-selection --title="Select a Script" --filename=$HOME/.local/bin/)

# Check if a script was selected
if [ -n "$SCRIPT" ]; then
  # Preview the selected script in gnome-text-editor
  gnome-text-editor "$SCRIPT"

  # Ask the user if they want to run the script
  if zenity --question --title="Run Script" --text="Do you want to run the selected script?"; then
    # Run the selected script with bash
    bash "$SCRIPT"
  fi
fi

# Clean up
rm -rf "$DOWNLOAD_PATH"
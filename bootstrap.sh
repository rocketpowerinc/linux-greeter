#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Function to check if a package is installed
check_package() {
  if command -v "$1" &>/dev/null; then
    echo -e "${GREEN}$1 is installed!${NC}"
  else
    echo -e "${RED}$1 is not installed.${NC}"
    if [ -f /etc/debian_version ]; then
      echo -e "${RED}You can install it using: sudo apt install $1${NC}"
    elif [ -f /etc/arch-release ]; then
      echo -e "${RED}You can install it using: sudo pacman -S $1${NC}"
    else
      echo -e "${RED}Please manually install $1 for your specific distro.${NC}"
    fi
  fi
}

# Check for zenity and yad
check_package zenity
check_package yad

sleep 2 #Time for wifi to connect

# Clone the repository into $HOME/Downloads
REPO_URL="https://github.com/rocketpowerinc/linux-greeter.git"
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Clean up
rm -rf "$DOWNLOAD_PATH"

# Clone repo
git clone "$REPO_URL" "$DOWNLOAD_PATH"

# chmod +x
find $DOWNLOAD_PATH -type f -name "*.sh" -exec chmod +x {} \;

# Run the script
"$HOME/Downloads/linux-greeter/pwr-greeter.sh"

# Clean up
rm -rf "$DOWNLOAD_PATH"

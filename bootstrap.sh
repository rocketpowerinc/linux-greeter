#!/usr/bin/env bash

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

#!/usr/bin/env bash

# Launch in new BlackBox terminal and get password via YAD
flatpak run com.raggesilver.BlackBox -- bash -c '
    PASSWORD=$(yad --entry --hide-text --title="Sudo Password" --text="Enter your sudo password:" --button="OK:0" --button="Cancel:1" --center)

    # Check if user clicked OK (exit code 0) or Cancel (exit code 1)
    if [ $? -eq 0 ]; then
        # Run the upgrade commands with the password
        echo "$PASSWORD" | sudo -S apt update && \
        echo "$PASSWORD" | sudo -S apt upgrade -y
        # Keep terminal open after completion
        echo "Upgrade complete. Press Enter to close..."
        read
    else
        echo "Operation cancelled"
        sleep 2
    fi
'

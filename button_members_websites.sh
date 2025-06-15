#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

# Create an inline shell script to open multiple websites
WEBSITES=$(cat << 'EOF'
xdg-open https://www.rottentomatoes.com/ &
xdg-open https://ext.to/ &
xdg-open https://torrentgalaxy.one/ &
xdg-open https://pcgamestorrents.com/ &
xdg-open https://www.ziperto.com/ &
xdg-open https://yts.hn/ &
xdg-open https://thepiratebay10.xyz/ &
EOF
)

# Display the main menu
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Favorite Websites Menu</span>\n\n\n" \
  --field="🏴‍☠️     Websites":FBTN "bash -c \"$WEBSITES\"" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?
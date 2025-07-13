#!/usr/bin/env bash

DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

#######################################
# Create an inline shell script to open multiple websites
PIRATE_WEBSITES=$(cat << 'EOF'
xdg-open https://www.rottentomatoes.com/ &
sleep 1s
xdg-open https://ext.to/ &
sleep 1s
xdg-open https://torrentgalaxy.one/ &
sleep 1s
xdg-open https://pcgamestorrents.com/ &
sleep 1s
xdg-open https://www.ziperto.com/ &
sleep 1s
xdg-open https://yts.hn/ &
sleep 1s
xdg-open https://thepiratebay10.xyz/ &
EOF
)
################################



#!######################

# Display the main menu
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Favorite Websites Menu</span>\n\n\n" \
  --field="🏴‍☠️     Pirating":FBTN "bash -c \"$PIRATE_WEBSITES\"" \
  --field="🦊     Firefox Bookmarks":FBTN "bash -c 'curl -L -o \"$HOME/Downloads/PUBLIC-bookmarks-latest.json\" https://raw.githubusercontent.com/rocketpowerinc/appbundles/main/Firefox-Bookmarks/PUBLIC-bookmarks-latest.json && echo -e \"\e[32mbookmarks.json saved to \$HOME/Downloads/\e[0m\" && read -p \"Press Enter to exit...\"'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?
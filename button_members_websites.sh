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


#######################################
# Function to clone bookmarks repo
clone_bookmarks_repo() {
  mkdir -p "$HOME/Downloads/Temp"
  cd "$HOME/Downloads/Temp" || exit

  [ -d "bookmarks" ] && rm -rf "bookmarks"
  git clone "https://github.com/rocketpowerinc/bookmarks"

  # Show yad popup with hardcoded path
  yad --title="🦊 Firefox Bookmarks" \
      --center --width=400 --height=150 \
      --text="✅ <b>Bookmarks Downloaded</b>\n\nPlease restore your Firefox bookmarks from:\n<b>$HOME/Downloads/Temp/PUBLIC-bookmarks-latest.json</b>" \
      --button=OK
}

# Export function for yad subprocess
export -f clone_bookmarks_repo

#######################################

#!######################

# Display the main menu
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Favorite Websites Menu</span>\n\n\n" \
  --field="🏴‍☠️     Sail the High Seas":FBTN "bash -c \"$PIRATE_WEBSITES\"" \
  --field="🦊     Firefox Bookmarks":FBTN "bash -c clone_bookmarks_repo" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?
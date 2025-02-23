#!/usr/bin/env bash

show_menu() {
  local distro=$1
  export -f cheatsheet
  export -f update_system

  yad --title="Manage $distro" \
    --width=600 --height=600 \
    --form --columns=2 --align=center --no-buttons --dark \
    --text-align=center --text="<span size='x-large' foreground='gold'>🚀⚡ Manage $distro ⚡🚀</span>\n\n" \
    --field="📖 Cheatsheet":FBTN "bash -c 'cheatsheet \"$distro\"'" \
    --field="♻️ Update":FBTN "bash -c 'update_system \"$distro\"'" \
    --field="❌ Exit":FBTN "bash -c 'pkill yad'"

  if [[ $? -eq 1 ]]; then
    return # Go back to the main menu
  fi
}

export -f show_menu

cheatsheet() {
  local distro=$1
  case "$distro" in
  Debian)
    xdg-open "https://rocketdashboard.notion.site/pwr-Debian-Cheat-sheet-1a3627bc6fd880e8aaaacde44983ba26?pvs=4"
    ;;
  Arch)
    xdg-open "https://rocketdashboard.notion.site/pwr-arch-Cheat-Sheet-1a3627bc6fd880fa9301d4660c4f2017?pvs=4"
    ;;
  Nix)
    xdg-open "https://rocketdashboard.notion.site/pwr-nix-Cheat-Sheet-1a3627bc6fd880d18d1fee8e97f0e7fc?pvs=4"
    ;;
  esac
}

export -f cheatsheet

# Function to update the system
update_system() {
  local distro=$1
  case "$distro" in
  Debian)
    # Show the dialog and get the user's response
    #response=$(yad --title="System Update" --text="This will run \`sudo apt update &amp;&amp; sudo apt upgrade -y\`. Continue?" --button="Yes:0" --button="No:1")
    response=$(yad --title="System Update" --text="RUN: sudo apt update &amp;&amp; sudo apt upgrade -y" --button="Yes:0" --button="No:1")


    # Check the user's response
    if [[ $? -eq 0 ]]; then
      # User clicked "Yes"
      x-terminal-emulator -e bash -c "sudo apt update && sudo apt upgrade -y; echo 'Press Enter to exit...'; read"
    else
      # User clicked "No"
      echo "Operation cancelled."
    fi
    ;;
  Arch)
    if [ -n "$WAYLAND_DISPLAY" ]; then
      kitty -- bash -c "sudo pacman -Syu --noconfirm; echo 'Press Enter to exit...'; read"
    elif [ -n "$DISPLAY" ]; then
      x-terminal-emulator -e bash -c "sudo pacman -Syu --noconfirm; echo 'Press Enter to exit...'; read"
    else
      echo "No display server found."
    fi
    ;;
  Nix)
    x-terminal-emulator -e bash -c "nix-channel --update && nix-env -u; echo 'Press Enter to exit...'; read"
    ;;
  esac
}

export -f update_system

#*################################ MUST BE AT THE BOTTOM ################################

yad --title="Select Distro" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large' foreground='gold'>🚀⚡ Select Your Distro ⚡🚀</span>\n\n" \
  --field="🐧 Nix":FBTN "bash -c 'show_menu Nix'" \
  --field="🐧 Debian":FBTN "bash -c 'show_menu Debian'" \
  --field="🐧 Arch":FBTN "bash -c 'show_menu Arch'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

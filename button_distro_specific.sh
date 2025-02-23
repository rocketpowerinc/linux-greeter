#!/usr/bin/env bash

show_menu() {
  local distro=$1
  export -f cheatsheet
  export -f update_system

  yad --form --center --title "Manage $distro" --width=600 --height=400 \
    --button=Back:1 --button=OK:0 --button=Cancel:252 \
    --field="Install":BTN "bash -c 'cheatsheet "$distro"'" \
    --field="Update":BTN "bash -c 'update_system "$distro"'"

  case $? in
  1)
    return # Go back to the previous screen
    ;;
  252)
    exit 0 # Exit if cancel button is clicked
    ;;
  esac
}

cheatsheet() {
  local distro=$1
  case "$distro" in
  Debian)
    x-terminal-emulator -e bash -c "nano cheatsheet.md"
    ;;
  Arch)
    x-terminal-emulator -e bash -c "sudo pacman -S --noconfirm <package>; echo 'Press Enter to exit...'; read"
    ;;
  Nix)
    x-terminal-emulator -e bash -c "nix-env -i <package>; echo 'Press Enter to exit...'; read"
    ;;
  esac
}

update_system() {
  local distro=$1
  case "$distro" in
  Debian)
    x-terminal-emulator -e bash -c "sudo apt update && sudo apt upgrade -y; echo 'Press Enter to exit...'; read"
    ;;
  Arch)
    x-terminal-emulator -e bash -c "sudo pacman -Syu --noconfirm; echo 'Press Enter to exit...'; read"
    ;;
  Nix)
    x-terminal-emulator -e bash -c "nix-channel --update && nix-env -u; echo 'Press Enter to exit...'; read"
    ;;
  esac
}

while true; do
  distro=$(yad --list --radiolist --column "Select" --column "Distro" \
    FALSE Nix FALSE Debian FALSE Arch \
    --title "Select Distro" --center --width=600 --height=400 --print-column=2 --separator="\n")

  case $? in
  1 | 252)
    exit 0 # Exit if cancel or close button is clicked
    ;;
  esac

  if [ -n "$distro" ]; then
    distro=$(echo "$distro" | tr -d '|')
    show_menu "$distro"
  fi
done

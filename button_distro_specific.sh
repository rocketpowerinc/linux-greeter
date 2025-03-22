#!/usr/bin/env bash

# Function to show the menu for each distribution
show_menu() {
  local distro=$1
  export -f cheatsheet
  export -f update_system
  export -f rebuild_nixos

  case "$distro" in
  Debian)
    local title="<span size='x-large' foreground='violet'>$(printf '\uF306')   $distro - Dashboard   $(printf '\uF306')</span>\n\n"
    ;;
  Arch)
    local title="<span size='x-large' foreground='lightblue'>$(printf '\uF303')   $distro - Dashboard   $(printf '\uF303')</span>\n\n"
    ;;
  Nix)
    local title="<span size='x-large' foreground='blue'>$(printf '\uF313')   $distro - Dashboard   $(printf '\uF313')</span>\n\n"
    ;;
  RaspberryPi)
    local title="<span size='x-large' foreground='purple'>$(printf '\uF315')   $distro - Dashboard   $(printf '\uF315')</span>\n\n"
    ;;
  *)
    local title="<span size='x-large' foreground='red'>$(printf '\uF306')   $distro - Dashboard   $(printf '\uF306')</span>\n\n"
    ;;
  esac

  if [[ "$distro" == "Nix" ]]; then
    # Only show the "Rebuild NixOS" button if the distro is Nix
    yad --title="" \
      --width=600 --height=600 \
      --form --columns=2 --align=center --no-buttons --dark \
      --text-align=center --text="$title" \
      --field="📖 Cheatsheet":FBTN "bash -c 'cheatsheet \"$distro\"'" \
      --field="♻️ Update":FBTN "bash -c 'update_system \"$distro\"'" \
      --field="🔄 Rebuild NixOS":FBTN "bash -c 'rebuild_nixos'" \
      --field="❌ Exit":FBTN "bash -c 'pkill yad'"
  else
    # Show the menu without the "Rebuild NixOS" button for other distros
    yad --title="" \
      --width=600 --height=600 \
      --form --columns=2 --align=center --no-buttons --dark \
      --text-align=center --text="$title" \
      --field="📖 Cheatsheet":FBTN "bash -c 'cheatsheet \"$distro\"'" \
      --field="♻️ Update":FBTN "bash -c 'update_system \"$distro\"'" \
      --field="❌ Exit":FBTN "bash -c 'pkill yad'"
  fi

  if [[ $? -eq 1 ]]; then
    return # Go back to the main menu
  fi
}

# Export the show_menu function
export -f show_menu

# Function to open the cheatsheet based on the distro
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
  RaspberryPi)
    xdg-open "https://rocketdashboard.notion.site/pwr-raspberrypi-Cheat-Sheet-1a3627bc6fd880d18d1fee8e97f0e7fc?pvs=4"
    ;;
  esac
}

# Export the cheatsheet function
export -f cheatsheet

# Function to update the system based on the distro
update_system() {
  local distro=$1
  case "$distro" in
  Debian)
    # Show the dialog and get the user's response
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
  RaspberryPi)
    x-terminal-emulator -e bash -c "sudo apt update && sudo apt upgrade -y; echo 'Press Enter to exit...'; read"
    ;;
  esac
}

# Export the update_system function
export -f update_system

# Function to rebuild NixOS system
rebuild_nixos() {
  # Trigger the nixos rebuild switch command with sudo
  sudo nixos-rebuild switch
}

# Export the rebuild_nixos function
export -f rebuild_nixos

# Main menu for selecting the distribution
yad --title="Select Distro" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large' foreground='grey'>Select Your Distro</span>\n\n" \
  --field="$(printf '\uF313')   Nix":FBTN "bash -c 'show_menu Nix'" \
  --field="$(printf '\uF306')   Debian":FBTN "bash -c 'show_menu Debian'" \
  --field="$(printf '\uF303')   Arch":FBTN "bash -c 'show_menu Arch'" \
  --field="$(printf '\uF315')   Raspberry Pi":FBTN "bash -c 'show_menu RaspberryPi'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

#!/usr/bin/env bash
# Detecting the Linux distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "Unknown"
  fi
}

# Defining update and cleanup commands for each distro
update_and_cleanup() {
  distro=$1
  case $distro in
    ubuntu)
      sudo apt update && sudo apt upgrade -y
      sudo apt autoremove
      sudo apt clean
      flatpak update --noninteractive
      flatpak uninstall --unused --noninteractive
      exit
      ;;
    debian)
      sudo aptitude update && sudo aptitude safe-upgrade -y && sudo aptitude full-upgrade -y && sudo aptitude clean
      flatpak update --noninteractive
      flatpak uninstall --unused --noninteractive
      exit
      ;;
    arch)
      sudo pacman -Syu && sudo paccache -r && sudo pacman -Rns $(pacman -Qtdq)
      flatpak update --noninteractive
      flatpak uninstall --unused --noninteractive
      exit
      ;;
    fedora)
      sudo dnf check-update && sudo dnf upgrade -y
      sudo dnf autoremove -y && sudo dnf clean all
      flatpak update --noninteractive
      flatpak uninstall --unused --noninteractive
      exit
      ;;
    opensuse)
      sudo zypper dup --allow-vendor-change && sudo zypper refresh && sudo zypper update && sudo zypper patch && sudo zypper install-new-recommends
      sudo zypper clean
      flatpak update --noninteractive
      flatpak uninstall --unused --noninteractive
      exit
      ;;
    nixos)
      sudo nix-channel --update
      sudo nixos-rebuild switch --upgrade
      nix-collect-garbage -d
      flatpak update --noninteractive
      flatpak uninstall --unused --noninteractive
      exit
      ;;
    *)
      echo "Unsupported Linux distribution: $distro"
      exit 1
      ;;
  esac
}

# Running the script
distro=$(detect_distro)
echo "Detected Linux distribution: $distro"
update_and_cleanup $distro

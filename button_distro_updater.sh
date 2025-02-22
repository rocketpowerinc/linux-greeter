#!/usr/bin/env bash

# Prompt for sudo password using zenity
read -r -s -p "Enter sudo password: " sudo_password
echo ""

# Check if password is empty
if [[ -z "$sudo_password" ]]; then
  zenity --error --text="Password is required."
  exit 1
fi

# Detecting the Linux distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "Unknown"
  fi
}

# Defining update and cleanup commands for each distro, piping sudo_password into each sudo command.
update_and_cleanup() {
  distro=$1

  # Use a function to securely handle passwords with sudo.
  run_with_sudo() {
    local cmd="$1"
    echo "$sudo_password" | sudo -S $cmd || {
      zenity --error --text="Authentication failed."
      exit 1
    }

    # Clear input buffer after successful authentication.
    stty sane <&0 >&0

    # Remove cached credentials (optional).
    unset sudo_password

    return $?

  }

  case $distro in
  ubuntu)
    run_with_sudo 'apt update && apt upgrade -y'
    run_with_sudo 'apt autoremove'
    run_with_sudo 'apt clean'
    flatpak update --noninteractive && flatpak uninstall --unused --noninteractive || {
      zenity --error --text="Flatpak operations failed."
      exit
    }
    ;;
  debian)
    run_with_sudo 'aptitude update && aptitude safe-upgrade -y && aptitude full-upgrade -y && aptitude clean'
    flatpak update --noninteractive && flatpak uninstall --unused --noninteractive || {
      zenity --error --text="Flatpak operations failed."
      exit
    }
    ;;
  arch)
    run_with_sudo 'pacman -Syu'
    run_with_sudo 'paccache -r'
    run_with_sudo "pacman -Rns \$(pacman -Qtdq)"
    flatpak update --noninteractive && flatpak uninstall --unused --noninteractive || {
      zenity --error --text="Flatpak operations failed."
      exit
    }
    ;;
  fedora)
    run_with_sudo 'dnf check-update && dnf upgrade -y'
    run_with_sudo 'dnf autoremove' # Removed '-y' here as per previous feedback; adjust as needed.
    run_with_sudo 'dnf clean all'
    flatpak update --noninteractive && flatpak uninstall--unused--noninteractive || {
      zenity--error--text="Flatpackoperationsfailed."
      exit
    }
    ;;
  opensuse)
    echo opensuse unsupported currently due to zypper limitations requiring interactive input or additional configuration beyond simple piping of passwords. Adjust manually if needed.
    exit
    ;;
  nixos)
    echo nixos unsupported currently due to nix-channel/nixos-rebuild requiring interactive setup or additional configuration beyond simple piping of passwords. Adjust manually if needed.
    exit
    ;;
  *)
    echo "Unsupported Linux distribution: $distro"
    exit
    ;;
  esac

}

# Running the script (Note: Opensuse & NixOS are marked unsupported here due to their specific requirements.)
distro=$(detect_distro)
echo "Detected Linux distribution: $distro"

update_and_cleanup "$distro"

## Prompt for sudo password using zenity
#sudo_password=$(zenity --password --title="Authentication Required")
#
## Check if password is empty
#if [[ -z "$sudo_password" ]]; then
#  zenity --error --text="Password is required."
#  exit 1
#fi
#
## Detecting the Linux distribution
#detect_distro() {
#  if [ -f /etc/os-release ]; then
#    . /etc/os-release
#    echo $ID
#  else
#    echo "Unknown"
#  fi
#}
#
## Defining update and cleanup commands for each distro
#update_and_cleanup() {
#  distro=$1
#  case $distro in
#    ubuntu)
#      sudo apt update && sudo apt upgrade -y
#      sudo apt autoremove
#      sudo apt clean
#      flatpak update --noninteractive
#      flatpak uninstall --unused --noninteractive
#      exit
#      ;;
#    debian)
#      sudo aptitude update && sudo aptitude safe-upgrade -y && sudo aptitude full-upgrade -y && sudo aptitude clean
#      flatpak update --noninteractive
#      flatpak uninstall --unused --noninteractive
#      exit
#      ;;
#    arch)
#      sudo pacman -Syu && sudo paccache -r && sudo pacman -Rns $(pacman -Qtdq)
#      flatpak update --noninteractive
#      flatpak uninstall --unused --noninteractive
#      exit
#      ;;
#    fedora)
#      sudo dnf check-update && sudo dnf upgrade -y
#      sudo dnf autoremove -y && sudo dnf clean all
#      flatpak update --noninteractive
#      flatpak uninstall --unused --noninteractive
#      exit
#      ;;
#    opensuse)
#      sudo zypper dup --allow-vendor-change && sudo zypper refresh && sudo zypper update && sudo zypper patch && sudo zypper install-new-recommends
#      sudo zypper clean
#      flatpak update --noninteractive
#      flatpak uninstall --unused --noninteractive
#      exit
#      ;;
#    nixos)
#      sudo nix-channel --update
#      sudo nixos-rebuild switch --upgrade
#      nix-collect-garbage -d
#      flatpak update --noninteractive
#      flatpak uninstall --unused --noninteractive
#      exit
#      ;;
#    *)
#      echo "Unsupported Linux distribution: $distro"
#      exit 1
#      ;;
#  esac
#}
#
## Running the script
#distro=$(detect_distro)
#echo "Detected Linux distribution: $distro"
#update_and_cleanup $distro
#

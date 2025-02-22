#!/usr/bin/env bash

# Prompt for sudo password using zenity
sudo_password=$(zenity --password --title="Authentication Required")

# Check if password is empty
if [[ -z "$sudo_password" ]]; then
  zenity --error --text="Password is required."
  exit 1
fi

# Detecting Linux distribution...
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "Unknown"
  fi
}

update_and_cleanup() {
  distro=$1

  # Function to securely handle passwords with sudo.
  run_with_sudo() {
    local cmd="$1"
    echo "$sudo_password" | sudo -S $cmd || {
      zenity --error --text="Authentication failed."
      exit 1
    }

    return $?
  }

  # Open a new gnome-terminal and run the update commands
  gnome-terminal -- bash -c "
  case $distro in
    ubuntu|debian)
      run_with_sudo 'apt update' &&
      run_with_sudo 'apt upgrade -y' &&
      run_with_sudo 'apt autoremove -y' &&
      run_with_sudo 'apt clean' &&
      #flatpak update --noninteractive &&
      #flatpak uninstall --unused --noninteractive || {
      #  zenity --error --text='Flatpak operations failed.'
        exit 1
      }
      ;;
    arch)
      run_with_sudo 'pacman -Syu --noconfirm' &&
      run_with_sudo 'paccache -r' &&
      run_with_sudo 'pacman -Rns $(pacman -Qtdq) --noconfirm' &&
      flatpak update --noninteractive &&
      flatpak uninstall --unused --noninteractive || {
        zenity --error --text='Flatpak operations failed.'
        exit 1
      }
      ;;
    fedora)
      echo 'Fedora unsupported currently due to dnf limitations requiring interactive input or additional configuration beyond simple piping of passwords. Adjust manually if needed.'
      exit 1
      ;;
    opensuse|nixos)
      echo 'OpenSUSE/NixOS unsupported currently due to zypper/nix-channel limitations requiring interactive setup or additional configuration beyond simple piping of passwords. Adjust manually if needed.'
      exit 1
      ;;
    *)
      echo 'Unsupported Linux distribution: $distro'
      exit 1
  esac
  exec bash"
}

distro=$(detect_distro)
echo "Detected Linux distribution: $distro"

# Run the update and cleanup process in the background and show a progress bar with yad
(
  update_and_cleanup "$distro" &
  PID=$!
  while kill -0 $PID 2>/dev/null; do
    echo 10
    sleep 1
    echo 20
    sleep 1
    echo 30
    sleep 1
    echo 40
    sleep 1
    echo 50
    sleep 1
    echo 60
    sleep 1
    echo 70
    sleep 1
    echo 80
    sleep 1
    echo 90
    sleep 1
    echo 100
  done
) | yad --progress --title="Updating System" --percentage=0 --auto-close --auto-kill

#!/usr/bin/env bash

# Function to update package database and install dependencies based on the distro
install_dependencies() {
  if [ -f /etc/debian_version ]; then
    # Debian-based
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y neovim git lazygit fzf ripgrep fd-find
  elif [ -f /etc/fedora-release ]; then
    # Fedora-based
    sudo dnf update -y
    sudo dnf install -y neovim git lazygit fzf ripgrep fd-find
  elif [ -f /etc/arch-release ]; then
    # Arch-based
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm neovim git lazygit fzf ripgrep fd
  elif [ -f /etc/SuSE-release ] || [ -f /etc/os-release ] && grep -q "openSUSE" /etc/os-release; then
    # openSUSE-based
    sudo zypper refresh
    sudo zypper install -y neovim git lazygit fzf ripgrep fd
  else
    echo "Unsupported Linux distribution."
    exit 1
  fi
}

# Backup old Neovim configuration
backup_old_config() {
  mv ~/.config/nvim{,.bak}
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}
}

# Clone LazyVim repository
setup_neovim() {
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
}

# Start Neovim to complete the setup
start_neovim() {
  nvim
}

# Main script execution
install_dependencies
backup_old_config
setup_neovim
start_neovim

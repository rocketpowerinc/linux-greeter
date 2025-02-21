#!/usr/bin/env bash

# Define the paths to important dot files
dotfiles=(
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.vimrc"
    "$HOME/.config/nvim/init.vim"
    "$HOME/.config/nvim/init.lua"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.profile"
    "$HOME/.bash_aliases"
    "$HOME/.inputrc"
    "$HOME/.config/nano/nanorc"
    "$HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings"
    "$HOME/.xinitrc"
    "$HOME/.config/i3/config"
    "$HOME/.config/openbox/rc.xml"
    "$HOME/.config/gtk-3.0/settings.ini"
    "$HOME/.config/mpv/mpv.conf"
    "$HOME/.config/terminator/config"
    "$HOME/.config/dunst/dunstrc"
    "$HOME/.ssh/config"
    "$HOME/.config/mutt/muttrc"
    "$HOME/.config/pacman/mirrorlist"
    "$HOME/.config/pip/pip.conf"
)

# Create a menu using Zenity
selection=$(zenity --list --title="Edit Dot Files" --column="Dot Files" "${dotfiles[@]}" --width=400 --height=300 --window-icon="gedit" --text="Select a dot file to edit:" --ok-label="Open" --cancel-label="Cancel")

# Check if the user selected a file
if [ $? -eq 0 ]; then
    gnome-text-editor "$selection"
fi

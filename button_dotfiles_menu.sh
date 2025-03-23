#!/usr/bin/env bash

# Variables
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"
DOTFILES="$HOME/Github/dotfiles"

# Fresh clone of the dotfiles repository
mkdir -p "$HOME/Github" && rm -rf "$HOME/Github/dotfiles" && git clone https://github.com/rocketpowerinc/dotfiles "$HOME/Github/dotfiles" && echo -e '\033[32mAll dotfiles refreshed!\033[0m'

# Display the main menu with buttons in the center of the fram
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Dotfiles Menu</span>\n\n\n" \
  --field="<span foreground='#FFFF00'>$(printf "\u270E\n")</span>     View Dotfiles":FBTN "bash -c '$DOWNLOAD_PATH/button_dotfiles_open.sh'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>       Copy bashrc":FBTN "bash -c 'grep -qxF \"source \\\"$DOTFILES/bash/bashrc\\\"\" ~/.bashrc || echo \"source \\\"$DOTFILES/bash/bashrc\\\"\" >> ~/.bashrc; echo -e \"\e[32m.bashrc has been copied!\e[0m\"'" \
  --field="<span foreground='#00FF00'>$(printf "\uF0C5\n")</span>     Copy zshrc":FBTN "bash -c '$DOTFILES/bash/bashrc'" \
  --field="<span foreground='#00FF00'>$(printf "\uF0C5\n")</span>     Copy pwsh profile.ps1":FBTN "bash -c '$DOTFILES/pwsh/profile.ps1'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

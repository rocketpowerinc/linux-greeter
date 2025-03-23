#!/usr/bin/env bash

# Variables
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"
DOTFILES="$HOME/Github/dotfiles"

# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Dotfiles Menu</span>\n\n\n" \
  --field="♻️     Refresh Dotfiles":FBTN "bash -c 'mkdir -p \"$HOME/Github\" && rm -rf \"$HOME/Github/dotfiles\" && git clone https://github.com/rocketpowerinc/dotfiles \"$HOME/Github/dotfiles\" && echo -e \"\e[32mAll dotfiles refreshed!\e[0m\"'" \
  --field="<span foreground='#FFFF00'>$(printf '\u270E')</span>     View Dotfiles":FBTN "bash -c '$DOWNLOAD_PATH/button_dotfiles_open.sh'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>     Source bashrc":FBTN "bash -c 'if grep -qxF \"source \\\"$DOTFILES/bash/bashrc\\\"\" ~/.bashrc; then \
    echo -e \"\e[33m.bashrc is already sourced!\e[0m\"; \
  else \
    echo \"source \\\"$DOTFILES/bash/bashrc\\\"\" >> ~/.bashrc; \
    echo -e \"\e[32m.bashrc has been sourced!\e[0m\"; \
  fi'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>     Source zshrc":FBTN "bash -c 'if grep -qxF \"source \\\"$DOTFILES/zsh/zshrc\\\"\" ~/.zshrc; then \
    echo -e \"\e[33m.zshrc is already sourced!\e[0m\"; \
  else \
    echo \"source \\\"$DOTFILES/zsh/zshrc\\\"\" >> ~/.zshrc; \
    echo -e \"\e[32m.zshrc has been sourced!\e[0m\"; \
  fi'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>     Source pwsh profile.ps1":FBTN "pwsh -c \"if (-not (Test-Path -Path $HOME/.config/powershell/profile.ps1)) { \
    New-Item -ItemType File -Path $HOME/.config/powershell/profile.ps1 -Force | Out-Null }; \
    if (-not (Get-Content $HOME/.config/powershell/profile.ps1 | Select-String -SimpleMatch '. \\\"$HOME/Github/dotfiles/pwsh/profile.ps1\\\"')) { \
    Add-Content -Path $HOME/.config/powershell/profile.ps1 -Value '. \\\"$HOME/Github/dotfiles/pwsh/profile.ps1\\\"'; \
    Write-Host -ForegroundColor Green 'pwsh profile has been sourced!' } else { \
    Write-Host -ForegroundColor Yellow 'pwsh profile already sourced!' }\"" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

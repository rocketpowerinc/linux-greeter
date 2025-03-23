#!/usr/bin/env bash

# Variables
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"
DOTFILES="$HOME/Github/dotfiles"

# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Dotfiles Menu</span>\n\n\n" \
  --field="♻️     Refresh Dotfiles":FBTN "bash -c 'mkdir -p \"$HOME/Github\" && \
    rm -rf \"$HOME/Github/dotfiles\" && \
    git clone https://github.com/rocketpowerinc/dotfiles \"$HOME/Github/dotfiles\" && \
    echo -e \"\e[32mAll dotfiles refreshed!\e[0m\"'" \
  --field="<span foreground='#FFFF00'>$(printf '\u270E')</span>     View Dotfiles":FBTN "bash -c '$DOWNLOAD_PATH/button_dotfiles_open.sh'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>     Source bashrc":FBTN "bash -c 'grep -qxF \"source \\\"$DOTFILES/bash/bashrc\\\"\" ~/.bashrc || \
    echo \"source \\\"$DOTFILES/bash/bashrc\\\"\" >> ~/.bashrc; \
    echo -e \"\e[32m.bashrc has been copied!\e[0m\"'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>     Source zshrc":FBTN "bash -c 'grep -qxF \"source \\\"$DOTFILES/zsh/zshrc\\\"\" ~/.zshrc || \
    echo \"source \\\"$DOTFILES/zsh/zshrc\\\"\" >> ~/.zshrc; \
    echo -e \"\e[32m.zshrc has been copied!\e[0m\"'" \
  --field="<span foreground='#00FF00'>$(printf '\uF0C5')</span>     Source pwsh profile.ps1":FBTN "pwsh -c \"if (-not (Test-Path -Path $HOME/.config/powershell/profile.ps1)) { \
    New-Item -ItemType File -Path $HOME/.config/powershell/profile.ps1 -Force | Out-Null }; \
    if (-not (Get-Content $HOME/.config/powershell/profile.ps1 | \
    Select-String -Pattern '\\. \\\"$env:HOME/Github/dotfiles/pwsh/profile.ps1\\\"')) { \
    Add-Content -Path $HOME/.config/powershell/profile.ps1 -Value '. \\\"$env:$HOME/Github/dotfiles/pwsh/profile.ps1\\\"'; \
    Write-Host -ForegroundColor Green 'pwsh profile has been copied!' } else { \
    Write-Host -ForegroundColor Yellow 'pwsh profile already sourced!' }\"" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

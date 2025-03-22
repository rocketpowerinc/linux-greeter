#!/usr/bin/env bash

# Display the main menu with buttons in the center of the fram
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large' foreground='gold'>🚀⚡ Welcome to the Power Greeter ⚡🚀</span>\n
<span size='x-large' foreground='green'>Linux Edition</span>\n\n\n" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF269')</span>     MX-Spins":FBTN "bash -c 'echo test'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Place Holder":FBTN "bash -c 'echo test'"


choice=$?

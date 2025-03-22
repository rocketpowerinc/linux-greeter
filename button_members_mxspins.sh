#!/usr/bin/env bash

# Display the main menu with buttons in the center of the fram
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large' foreground='grey'>Select Your Spin</span>\n\n\n" \
  --field="<span foreground='red'>$(printf '\uF135')</span>      Dev Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Doomsday Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Retro/Pirate Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Student Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='#FFFFFF'>$(printf '\uF0C7')</span>     Teacher Spin":FBTN "bash -c 'echo test'"

choice=$?

#!/usr/bin/env bash

# Display the main menu with buttons in the center of the fram
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large' foreground='grey'>Select Your Spin</span>\n\n\n" \
  --field="<span foreground='red'>$(printf '\uF135')</span>      Rocket/Dev Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='grey'>$(printf '\U0001F4A3')</span>     Doomsday/Prepper Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='green'>$(printf '\uF11B')</span>     Gaming/Pirate Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='pink'>$(printf '\uF5DC')</span>     Kids/Student Spin":FBTN "bash -c 'echo test'" \
  --field="<span foreground='blue'>$(printf '\U0001F4DA')</span>     Parent/Teacher Spin":FBTN "bash -c 'echo test'"

choice=$?

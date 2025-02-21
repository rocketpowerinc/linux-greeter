#!/usr/bin/env bash

# First try to run the Flatpak command
if flatpak run com.raggesilver.BlackBox --command="bash -c 'curl -fsSL https://christitus.com/linux | sh'"; then
  echo "Executed via Flatpak."
else
  # If the Flatpak command fails, try running blackbox directly
  if blackbox --command="bash -c 'curl -fsSL https://christitus.com/linux | sh'"; then
    echo "Executed directly."
  else
    echo "Both methods failed."
  fi
fi

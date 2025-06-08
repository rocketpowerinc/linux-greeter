#!/usr/bin/env bash

# Variables
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

#################################################

selfhost_filebrowser() {
  BASE_DIR="$HOME/Docker/filebrowser"
  COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

  # Ensure the base directory exists
  mkdir -p "$BASE_DIR"

  # Write the docker-compose.yml file
  cat > "$COMPOSE_FILE" <<EOF
services:
  filebrowser:
    image: hurlenko/filebrowser:latest
    container_name: filebrowser # custom name
    user: "\${UID}:\${GID}"
    ports:
      - 3000:8080
    volumes:
      - /home/rocket:/data #*Navigation Home directory
      - ./config:/config
    environment:
      - FB_BASEURL=/filebrowser
      - FB_NOAUTH=true #!Added NoAuth so Family members can access without passwords
    restart: unless-stopped

    #https://hub.docker.com/r/hurlenko/filebrowser
EOF

  # Navigate to the directory and start the container
  cd "$BASE_DIR" || return
  docker compose up -d

  # Notify the user
  echo "FileBrowser is now running at http://localhost:3000"
}

export -f selfhost_filebrowser

##############################################
# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Docker Menu</span>\n\n\n" \
  --field="🌪️     Selfhost Filebrowser":FBTN "bash -c 'selfhost_filebrowser'" \
  --field="🚧     Place Holder":FBTN "bash -c 'echo test'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?
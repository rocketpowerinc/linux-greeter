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
  cat >"$COMPOSE_FILE" <<EOF
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
  sudo docker compose up -d

  # Notify the user
  echo "FileBrowser is now running at http://localhost:3000"
}

export -f selfhost_filebrowser

#########################################################

selfhost_lazydocker() {
  BASE_DIR="$HOME/Docker/lazydocker"
  COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

  # Ensure the base directory exists
  mkdir -p "$BASE_DIR"

  # Write the docker-compose.yml file
  cat >"$COMPOSE_FILE" <<EOF
services:
  lazydocker:
    build:
      context: https://github.com/jesseduffield/lazydocker.git
      args:
        BASE_IMAGE_BUILDER: golang
        GOARCH: amd64
        GOARM:
    image: lazyteam/lazydocker
    container_name: lazydocker
    stdin_open: true
    tty: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config:/.config/jesseduffield/lazydocker
EOF

  # Navigate to the directory and build + run the container
  cd "$BASE_DIR" || return
  sudo docker compose up -d --build

  # Notify the user
  yad --info --text="Lazydocker is now running. Attach with:\n\n<b>sudo docker exec -it lazydocker lazydocker</b>"
}

export -f selfhost_lazydocker

#!######################      MENU         #######################
# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Docker Menu</span>\n\n\n" \
  --field="🌪️     Selfhost Filebrowser":FBTN "bash -c 'selfhost_filebrowser'" \
  --field="🚧     Selfhost Lazydocker":FBTN "bash -c 'selfhost_lazydocker'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

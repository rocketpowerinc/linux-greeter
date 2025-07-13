#!/usr/bin/env bash

# Variables
DOWNLOAD_PATH="$HOME/Downloads/linux-greeter"

reset_docker() {
  sudo docker stop $(sudo docker ps -q)
  sudo docker rm -f $(sudo docker ps -aq)
  sudo docker rmi $(sudo docker images -q)
  sudo docker volume prune -f
  sudo docker network prune -f
  sudo rm -rf $HOME/Docker/*/
  sudo rm -f $HOME/Docker/*
  sudo docker system prune -a --volumes -f
}
export -f reset_docker
#*################################################

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
  echo "http://localhost:3000" | yad --text-info \
    --title="FileBrowser Started" \
    --width=500 \
    --height=200 \
    --center \
    --window-icon=dialog-information \
    --no-buttons \
    --fontname="monospace 12" \
    --wrap \
    --text="<span foreground='cyan' weight='bold' size='20000'>FileBrowser now running at:</span>"

  xdg-open http://localhost:3000
}

export -f selfhost_filebrowser

#*########################################################

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
    restart: unless-stopped
EOF

  # Navigate to the directory and build + run the container
  cd "$BASE_DIR" || return
  sudo docker compose up -d --build

  # Notify the user
  echo "sudo docker exec -it lazydocker lazydocker" | yad --text-info \
    --title="Lazydocker command" \
    --width=500 \
    --height=200 \
    --center \
    --window-icon=dialog-information \
    --no-buttons \
    --fontname="monospace 12" \
    --wrap \
    --text="<span foreground='cyan' weight='bold' size='18000'>Run this command to view Lazydocker</span>"

}

export -f selfhost_lazydocker

#*########################################################

selfhost_portainer() {
  BASE_DIR="$HOME/Docker/portainer"
  COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

  # Ensure the base directory exists
  mkdir -p "$BASE_DIR"

  # Write the docker-compose.yml file
  cat >"$COMPOSE_FILE" <<EOF
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    ports:
      - 9443:9443
    volumes:
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
volumes:
  data:

EOF

  # Navigate to the directory and build + run the container
  cd "$BASE_DIR" || return
  sudo docker compose up -d --build

  # Notify the user
  echo "https://localhost:9443" | yad --text-info \
    --title="Portainer Started" \
    --width=500 \
    --height=200 \
    --center \
    --window-icon=dialog-information \
    --no-buttons \
    --fontname="monospace 12" \
    --wrap \
    --text="<span foreground='cyan' weight='bold' size='20000'>Portainer now running at:</span>"

  xdg-open http://localhost:9443

}

export -f selfhost_portainer

#*########################################################

selfhost_jdownloader() {
  BASE_DIR="$HOME/Docker/jdownloader"
  COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

  # Ensure the base directory exists
  mkdir -p "$BASE_DIR"

  # Write the docker-compose.yml file
  cat >"$COMPOSE_FILE" <<EOF
services:
  jdownloader-2:
    image: jlesage/jdownloader-2
    container_name: jdownloader-2
    ports:
      - "5800:5800"
    volumes:
      - /docker/appdata/jdownloader-2:/config:rw
      - /home/rocket/Downloads:/output:rw
    restart: unless-stopped

EOF

  # Navigate to the directory and build + run the container
  cd "$BASE_DIR" || return
  sudo docker compose up -d --build
  # Notify the user
  echo "http://localhost:5800" | yad --text-info \
    --title="Jdownloader Started" \
    --width=500 \
    --height=200 \
    --center \
    --window-icon=dialog-information \
    --no-buttons \
    --fontname="monospace 12" \
    --wrap \
    --text="<span foreground='cyan' weight='bold' size='20000'>Jdownloader2 now running at:</span>"

  xdg-open http://localhost:5800
}

export -f selfhost_jdownloader

#*########################################################

selfhost_wud() {
  BASE_DIR="$HOME/Docker/wud"
  COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

  # Ensure the base directory exists
  mkdir -p "$BASE_DIR"

  # Write the docker-compose.yml file
  cat >"$COMPOSE_FILE" <<EOF
services:
  whatsupdocker:
    image: getwud/wud:latest
    container_name: wud
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 3001:3000
    restart: unless-stopped


EOF

  # Navigate to the directory and build + run the container
  cd "$BASE_DIR" || return
  sudo docker compose up -d --build

  # Notify the user
  echo "http://localhost:3001" | yad --text-info \
    --title="WUD Started" \
    --width=500 \
    --height=200 \
    --center \
    --window-icon=dialog-information \
    --no-buttons \
    --fontname="monospace 12" \
    --wrap \
    --text="<span foreground='cyan' weight='bold' size='20000'>WUD now running at:</span>"

  xdg-open http://localhost:3001

}

export -f selfhost_wud

#*########################################################

selfhost_glance() {
  BASE_DIR="$HOME/Docker/glance"
  COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

  # Ensure the base directory exists
  mkdir -p "$BASE_DIR"

  # Write the docker-compose.yml file
  cat >"$COMPOSE_FILE" <<EOF
services:
  glance:
    container_name: glance
    image: glanceapp/glance
    restart: unless-stopped
    volumes:
      - ./config:/app/config
      - ./assets:/app/assets
      - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
      - 3002:8080
EOF

  # Navigate to the directory and build + run the container
  cd "$BASE_DIR" || return
  sudo docker compose up -d --build

  #todo########## Copy The dotfile
  REPO_URL="https://github.com/rocketpowerinc/dotfiles.git"
  CLONE_DIR="$HOME/Downloads/dotfiles"
  TARGET_PATH="$HOME/Docker/glance/config"

  # Force delete the directory if it already exists
  rm -rf "$CLONE_DIR"

  # Clone the repository
  git clone "$REPO_URL" "$CLONE_DIR"

  # Move the glance.yml file
  mv "$CLONE_DIR/glance/glance.yml" "$TARGET_PATH/"

  # Confirm success
  if [ $? -eq 0 ]; then
    echo "glance.yml moved to $TARGET_PATH"
  else
    echo "Failed to move glance.yml"
  fi

  # Notify the user
  echo "http://localhost:3002" | yad --text-info \
    --title="Glance Started" \
    --width=500 \
    --height=200 \
    --center \
    --window-icon=dialog-information \
    --no-buttons \
    --fontname="monospace 12" \
    --wrap \
    --text="<span foreground='cyan' weight='bold' size='20000'>WUD now running at:</span>"

  xdg-open http://localhost:3002

}

export -f selfhost_glance

#!######################      MENU         #######################
# Display the main menu with buttons in the center of the frame
yad --title="" \
  --width=600 --height=600 \
  --form --columns=2 --align=center --no-buttons --dark \
  --text-align=center --text="<span size='x-large'>Docker Menu</span>\n\n\n" \
  --field="🐳     Install Docker":FBTN "bash -c 'yad --info --title=\"Install Docker\" --width=800 --height=120 --center --window-icon=dialog-warning --markup --text=\"<span foreground=\\\"yellow\\\" size=\\\"large\\\">⚠️ Please install Docker using CTT LinUtil Script -> curl -fsSL https://christitus.com/linux | sh </span>\"'" \
  --field="🗑️     Reset Docker":FBTN "bash -c 'reset_docker'" \
  --field="🔑     Selfhost Filebrowser":FBTN "bash -c 'selfhost_filebrowser'" \
  --field="🔑     Selfhost Lazydocker":FBTN "bash -c 'selfhost_lazydocker'" \
  --field="🔑     Selfhost Portainer":FBTN "bash -c 'selfhost_portainer'" \
  --field="🔑     Selfhost Jdownloader2":FBTN "bash -c 'selfhost_jdownloader'" \
  --field="🔑     Selfhost WUD":FBTN "bash -c 'selfhost_wud'" \
  --field="🔑     Selfhost Glance Dashboard":FBTN "bash -c 'selfhost_glance'" \
  --field="❌ Exit":FBTN "bash -c 'pkill yad'"

choice=$?

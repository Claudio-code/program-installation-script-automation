#!/bin/bash

source ./util_functions.sh
source ./flatpak_install_apps.sh
source ./snap_install_apps.sh

DOCKER_ADD_PPA="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

LIST_APPS_APT=(
  build-essential
  libssl-dev
  zlib1g-dev
  libbz2-dev
  libreadline-dev
  wget
  curl
  llvm
  libncursesw5-dev
  xz-utils
  tk-dev
  libxml2-dev
  libxmlsec1-dev
  libffi-dev
  liblzma-dev
  flatpak
  onedrive
  zsh
  apt-transport-https
  ca-certificates
  lsb-release
  gnupg
  gnupg-agent
  software-properties-common
  unzip
  zip
  docker-ce
  docker-ce-cli
  containerd.io
  docker-compose-plugin
  docker-compose
)

remove_locks_ubu () {
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
}

update_system_ubu () {
  println_sucsess "Update system."
  remove_locks_ubu

  sudo autoclean &> /dev/null
  sudo apt-get update &> /dev/null
  sudo apt-get upgrade -y &> /dev/null
  sudo apt autoremove -y &> /dev/null
}

add_docker_ppa_ubu () {
  println_sucsess "Add docker ppa."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "$DOCKER_ADD_PPA" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

install_package_with_apt () {
  println_sucsess "Installing programs from ubuntu repository."
  for programs in ${LIST_APPS_APT[@]}; do
    if ! dpkg -l | grep -q $programs; then
      println_sucsess "The software $programs being installed."
      sudo apt install $programs -y &> /dev/null
    else
      println_sucsess "The software $programs has already been installed."
    fi
  done
  sudo usermod -aG docker ${USER}
}

startup_ubuntu () {
  update_system_ubu
  add_docker_ppa_ubu
  update_system_ubu
  install_package_with_apt
  update_system_ubu
  install_package_with_snaps
  install_package_with_flatpak
}

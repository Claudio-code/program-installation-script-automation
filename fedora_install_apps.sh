#!/bin/bash

source ./util_functions.sh
source ./flatpak_install_apps.sh
source ./snap_install_apps.sh

LIST_APPS_DNF=(
  flatpak
  snapd
  docker-ce
  docker-ce-cli
  containerd.io
  docker-compose-plugin
  docker-compose
)

add_rpm_fusion () {
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y &> /dev/null
  sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y &> /dev/null
}

update_system_fed () {
  println_sucsess "Updating system."
  sudo dnf update -y &> /dev/null
  sudo dnf -y install dnf-plugins-core &> /dev/null
}
add_docker_repo () {
  println_sucsess "Adding docker repository."
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  update_system_fed
}

install_apps_dnf () {
  println_sucsess "Installing programs from fedora repository."
  sudo yum groupinstall "Development Tools" "Development Libraries" -y &> /dev/null
  for programs in ${LIST_APPS_DNF[@]}; do
    println_sucsess "The software $programs being installed."
    sudo dnf install $programs -y &> /dev/null
  done
  sudo ln -s /var/lib/snapd/snap /snap
  sudo usermod -aG docker ${USER}
}

startup_fedora () {
  update_system_fed
  add_rpm_fusion
  update_system_fed
  install_apps_dnf
  install_package_with_snaps
  install_package_with_flatpak
}

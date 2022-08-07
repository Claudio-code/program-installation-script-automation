#!/bin/bash

source ./util_functions.sh

SOFTWARE_TO_INSTALL_SNAPS=(
  1password
  teams
  notion-snap
)

SOFTWARE_TO_INSTALL_SNAPS_LEGACY=(
  code
  kontena-lens
  intellij-idea-community
)

install_package_with_snaps () {
  println_sucsess "Downloading packages snaps."

  for programs in ${SOFTWARE_TO_INSTALL_SNAPS[@]}; do
    if ! snap list | grep $programs; then
      println_sucsess "The software $programs being installed."
      sudo snap install $programs -y &> /dev/null
    else
      println_sucsess "The software $programs has already been installed."
    fi
  done

  for programs in ${SOFTWARE_TO_INSTALL_SNAPS_LEGACY[@]}; do
    if ! snap list | grep $programs; then
      println_sucsess "The software $programs being installed."
      sudo snap install $programs --classic &> /dev/null
    else
      println_sucsess "The software $programs has already been installed."
    fi
  done
}

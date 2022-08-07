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
  kubectl
)

install_package_with_snaps () {
  println_sucsess "Downloading packages snaps."

  for programs in ${SOFTWARE_TO_INSTALL_SNAPS[@]}; do
    println_sucsess "The software $programs being installed."
    sudo snap install $programs &> /dev/null
  done

  for programs in ${SOFTWARE_TO_INSTALL_SNAPS_LEGACY[@]}; do
    println_sucsess "The software $programs being installed."
    sudo snap install $programs --classic &> /dev/null
  done
}

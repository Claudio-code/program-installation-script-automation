#!/bin/bash

source ./util_functions.sh

LIST_APPS_FLATPAK=(
  com.slack.Slack
  com.discordapp.Discord
  com.getpostman.Postman
  com.spotify.Client
  org.keepassxc.KeePassXC
  io.dbeaver.DBeaverCommunity
  com.todoist.Todoist
  com.github.marktext.marktext
  us.zoom.Zoom
  org.gnome.Boxes
)

add_flathub_repository () {
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_package_with_flatpak () {
  println_sucsess "Installing programs from flathub repository."
  add_flathub_repository
  for programs in ${LIST_APPS_FLATPAK[@]}; do
    println_sucsess "The software $programs being installed."
    flatpak install flathub $programs -y
  done
}

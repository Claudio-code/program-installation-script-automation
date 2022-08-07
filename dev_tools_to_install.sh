#!/bin/bash

source ./util_functions.sh

JAVA_VERSIONS=(
    18.0.2-amzn
    17.0.4-amzn
    11.0.16-amzn
)

ANOTHER_JDK_TOOLS=(
    gradle
    maven
    groovy
)

ASDF_PLUGIN_TOOLS=(
  python
  nodejs
)


install_sdkman () {
  println_sucsess "Installing sdkman to install multiple jdk version and another tools."
  curl -s "https://get.sdkman.io" | bash && source "$HOME/.sdkman/bin/sdkman-init.sh"  &> /dev/null
}

install_jdk_tools () {
  println_sucsess "Installing Java versions by sdkman repository."
  install_sdkman
  for version in ${JAVA_VERSIONS[@]}; do
    println_sucsess "The java $version being installed."
    sdk install java $version &> /dev/null
  done

  println_sucsess "Installing Jdk tools versions by sdkman repository."
  for programs in ${ANOTHER_JDK_TOOLS[@]}; do
    println_sucsess "The software $programs being installed."
    sdk install $programs &> /dev/null
  done
}

install_asdf () {
  println_sucsess "Install asdf-vm."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf && echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc
  source "$HOME/.zshrc"
}


add_plugin_asdf () {
  println_sucsess "Add dev plataforms in asdf path."
  install_asdf
  for programs in ${ASDF_PLUGIN_TOOLS[@]}; do
    println_sucsess "The $programs added in asdf path."
    asdf plugin-add $programs &> /dev/null
  done
}

install_last_dev_plataforms_version () {
  println_sucsess "Instaling the last versions that dev plataforms used by me."
  for programs in ${ASDF_PLUGIN_TOOLS[@]}; do
    asdf install $programs latest &> /dev/null
    println_sucsess "The $programs last verison installed."
  done
}

install_all_dev_tools () {
  install_jdk_tools
  add_plugin_asdf
  install_last_dev_plataforms_version
}

install_all_dev_tools

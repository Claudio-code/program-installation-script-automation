#!/bin/bash

source ./util_functions.sh
source ./flatpak_install_apps.sh
source ./snap_install_apps.sh
source ./ubuntu_install_apps.sh
source ./fedora_install_apps.sh

distro=`lsb_release -is`

case $distro in

  Linuxmint)
    println_sucsess "Install apps in Ubuntu"
    startup_ubuntu
    ;;

  Ubuntu)
    println_sucsess "Install apps in Ubuntu"
    startup_ubuntu
    ;;

   Fedora)
    println_sucsess "Install apps in Fedora"
    startup_fedora
    ;;

  *)
    println_sucsess "I couldn't identify your system."
    ;;
esac

git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./kubernetes_cluster_install.sh
mkdir "$HOME/.kube"
multipass exec kube-node-master -- bash -c "sudo cat /etc/kubernetes/admin.conf" > "$HOME/.kube/config"

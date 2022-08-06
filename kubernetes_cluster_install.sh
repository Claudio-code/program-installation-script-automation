#!/bin/bash

multipass_install () {
    sudo snap refresh
    sudo snap install multipass
}

create_clusters () {
    multipass launch -n kube-node-master -m 4294967296 -c 2
    multipass launch -n kube-node-one -m 4294967296 -c 2
    multipass launch -n kube-node-two -m 4294967296 -c 2
}

create_two_node_clusters () {
    multipass exec kube-node-two -- bash -c 'sudo apt update && sudo apt upgrade -y && git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./install_how_root_node.sh'
    multipass exec kube-node-one -- bash -c 'sudo apt update && sudo apt upgrade -y && git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./install_how_root_node.sh'
}

added_nodes_to_cluster () {
    local kubeadm_token="$1"
    multipass exec kube-node-two -- bash -c "$kubeadm_token"
    multipass exec kube-node-one -- bash -c "$kubeadm_token"
}


create_cluster_master () {
    local command_output="`multipass exec kube-node-master -- bash -c 'sudo apt update && sudo apt upgrade -y && git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./install_how_root.sh'`"
    added_nodes_to_cluster `echo $command_output | grep -o -P '(?<=root:).*(?=WARNING)'`
}

multipass_install
create_clusters
create_two_node_clusters
create_cluster_master

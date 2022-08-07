#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

println () {
  local message="$1"
  echo -e "\n ${GREEN}[INFO]${NC} - ${message} \n"
}

multipass_install () {
    println "Installing multipass."
    sudo snap refresh
    sudo snap install multipass
}

create_clusters () {
    println "Creating three virtual-machines to use in your cluster."
    multipass launch -n kube-node-master -m 4294967296 -c 2
    multipass launch -n kube-node-one -m 4294967296 -c 2
    multipass launch -n kube-node-two -m 4294967296 -c 2
}

update_cluster_nodes () {
    println "Updating three virtual-machines."
    multipass exec kube-node-two -- bash -c 'sudo apt update && sudo apt upgrade -y'
    multipass exec kube-node-one -- bash -c 'sudo apt update && sudo apt upgrade -y'
    multipass exec kube-node-master -- bash -c 'sudo apt update && sudo apt upgrade -y'
}

add_kube_config_in_nodes () {
    println "adding env kubeconfig in three virtual-machines."
    multipass exec kube-node-master -- bash -c "echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> .bashrc"
    multipass exec kube-node-one -- bash -c "echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> .bashrc"
    multipass exec kube-node-two -- bash -c "echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> .bashrc"
}

add_kubernetes_in_two_node_clusters () {
    println "adding k8s in two virtual-machines."
    multipass exec kube-node-two -- bash -c 'git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./install_how_root_node.sh'
    multipass exec kube-node-one -- bash -c 'git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./install_how_root_node.sh'
}

added_nodes_to_cluster () {
    println "adding token to connect nodes in master."
    local kubeadm_token="$1"
    multipass exec kube-node-two -- bash -c "sudo $kubeadm_token"
    multipass exec kube-node-one -- bash -c "sudo $kubeadm_token"
}

add_kubernetes_in_cluster_master () {
    println "adding k8s in node-master and creating kube token."
    multipass exec kube-node-master -- bash -c "git clone https://github.com/Claudio-code/script-to-install-kubernetes.git && cd ./script-to-install-kubernetes && sudo ./install_how_root.sh"
    local command_output=`multipass exec kube-node-master -- bash -c "sudo kubeadm token create --print-join-command"`
    added_nodes_to_cluster "$command_output"
}

multipass_install
create_clusters
update_cluster_nodes
add_kube_config_in_nodes
add_kubernetes_in_two_node_clusters
add_kubernetes_in_cluster_master

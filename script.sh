#!/bin/bash

PPA_NODEJS="https://deb.nodesource.com/setup_15.x"
PPA_DOCKER="deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
PPA_PHP="ppa:ondrej/php"

URL_ADD_FLATHUB="https://flathub.org/repo/flathub.flatpakrepo"
URL_DOWNLOAD_COMPOSER="https://getcomposer.org/installer"

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo dpkg --add-architecture i386
sudo apt update

# install libs
sudo apt -f install -y
sudo apt install  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  flatpak \
  git \
  zsh \
  snapd \
  build-essential \
  unzip

# install NodeJs lts
curl -sL "$PPA_NODEJS" | sudo bash
sudo apt update
sudo apt-get install nodejs -y
sudo npm i -g yarn eslint nodemon

# install docker
sudo add-apt-repository "$PPA_DOCKER"
sudo apt-get update
sudo apt install docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose

sudo usermod -aG docker ${USER}

# install PHP
sudo add-apt-repository "$PPA_PHP" -y
sudo apt update
sudo apt-get install  php7.4 \
  mcrypt \
  php7.4-xml \
  php7.4-curl \
  php7.4-mysql \
  php7.4-zip \
  php7.4-mbstring \
  php7.4-pgsql \
  libapache2-mod-php \
  php7.4-gd \
  php7.4-json \
  php7.4-soap \ 
  php \
  php-xml \
  php-curl \
  php-mysql \
  php-zip \
  php-mbstring \
  php-pgsql \
  php-soap \
  php-cli \
  php-json \
  php-gd

sudo apt remove apache2 -y

# install package manager to PHP composer
curl -sS "$URL_DOWNLOAD_COMPOSER" -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo rm -R composer-setup.php

# install apps snaps
sudo snap install code --classic
sudo snap install phpstorm --classic
sudo snap install kubectl --classic

#install apps flatpak
flatpak remote-add --if-not-exists flathub "$URL_ADD_FLATHUB" 
flatpak install flathub com.slack.Slack 
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.getpostman.Postman
flatpak install flathub io.dbeaver.DBeaverCommunity

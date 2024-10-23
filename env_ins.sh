#! /bin/bash

apt-update -y
apt-upgrade -y
apt remove iptables* -y
apt autoremove -y

echo "start to install neccessary tool from apt"

apt install jq -y
apt install snap -y

snap install core


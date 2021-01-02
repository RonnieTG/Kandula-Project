#!/bin/bash

# Software management
sudo apt update
sudo apt install software-properties-common

# Install Python3 as prerequisite
sudo apt install python3

# Install Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Create roles for Consul installation
ansible-galaxy collection install community.general
echo "ansible-galaxy init roles/consul"
echo ""
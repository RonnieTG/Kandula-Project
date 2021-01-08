#!/bin/bash

# Software management
sudo apt update
sudo apt install software-properties-common

# Install Python3 as prerequisite
sudo apt install python3

# Install Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
ansible-galaxy collection install community.general

# Prepare Ansible for running playbooks
cat <<EOT > /etc/ansible/hosts
[docker] 
Kandula-PROD-Docker-Server-01

[localhost] 
localhost ansible_connection=local

[localhost:vars] 
ansible_python_interpreter=/usr/bin/python3 

EOT

sudo mkdir /home/ubuntu/ansible
cd /home/ubuntu/ansible
sudo ansible-galaxy init roles/docker
sleep 15

# Create a playbook for Docker installation
cat <<EOF  > /home/ubuntu/ansible/roles/docker/tasks/main.yml
--- 

- name: Uninstall old Docker versions 
  apt: 
    name: ['docker', 'docker-engine', 'docker.io', 'containerd', 'runc'] 
    state: absent 
    force: yes 

- name: Pre-installations for Docker repository 
  apt: 
    name: ['apt-transport-https','ca-certificates','curl','software-properties-common','gnupg-agent', 'python3-pip'] 
    update_cache: yes 

- name: Add Docker GPG key 
  apt_key: 
    id: 0EBFCD88 
    url: https://download.docker.com/linux/ubuntu/gpg 
    state: present 

- name: Add Docker repository 
  apt_repository: 
    repo: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable' 
    state: present 
    filename: docker 

- name: Install docker-ce 
  apt: 
    name: ['docker-ce','docker-ce-cli','containerd.io'] 
    update_cache: yes 
  notify: 
  - restart docker-ce 

- name: Add user ubuntu to docker group 
  user: 
    name: ubuntu 
    group: docker 

- name: Install docker-py for docker container plugin 
  pip: 
    name: docker-py 
    state: present

EOF

cat <<EOR > /home/ubuntu/ansible/roles/install_docker.yml
---

- name: install docker
  hosts: docker
  remote_user: ubuntu
  become: yes
  roles: 
  - docker

EOR

sleep 120
cd /home/ubuntu/ansible/roles/
sudo ansible-playbook -i docker install_docker.yml
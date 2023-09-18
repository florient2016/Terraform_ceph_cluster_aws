#!/bin/bash
sudo mkdir /home/ec2-user/tete
sudo yum install vim python3-pip git sshpass yum-utils lvm2  -y
sudo useradd -m -d /home/ansible ansible -G wheel
sudo echo 'ansible  ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible
sudo echo ceph | passwd --stdin ansible
sudo echo ceph | passwd --stdin root
sudo chown ansible:ansible /etc/sudoers.d/ansible
sudo chown ansible:ansible /home/ansible/*
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/gI' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/gI' /etc/ssh/sshd_config
sudo sed -i 's/# %wheel/%wheel/gI' /etc/sudoers
sudo systemctl restart sshd
sudo echo 'ansible  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers


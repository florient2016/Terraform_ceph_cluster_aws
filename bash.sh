#!/bin/bash
sudo yum install vim python3-pip httpd-tools git sshpass yum-utils lvm2  -y
sudo pip3 install ansible
sudo yum update -y
sudo curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
sudo chmod +x cephadm
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo ./cephadm add-repo --release reef
sudo ./cephadm install
sudo cephadm install ceph-common
sudo useradd -m -d /home/ansible ansible -G wheel
sudo echo 'ansible  ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible
sudo echo ceph | passwd --stdin ansible
sudo runuser -l ansible -c 'ssh-keygen'
pip3 install boto3
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/gI' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/gI' /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo cat >> /etc/hosts << TTH
x.x.x.x manage.example.com  manage
x.x.x.x client.example.com  client
x.x.x.x server1.example.com server1
x.x.x.x server2.example.com server2
x.x.x.x server3.example.com server3
x.x.x.x grafana.example.com grafana
TTH

cat > /home/ansible/inventory << EOF
[client]
client
[osds]
server1
server2
server3
[grafanas]
grafana
EOF

cat > /home/ansible/ansible.cfg << EOL
[defaults]
inventory = /home/ansible/inventory
host_key_checking = fasle
remote_user = ansible
[privilege_escalation]
become = true
become_user = root
become_ask_pass = false
become_method = sudo
EOL

cat > /home/ansible/ceph-deploy.repo << EOL
[ceph-noarch]
name= Ceph noarch packages
baseurl= https://download.ceph.com/rpm-mimic/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey= https://download.ceph.com/keys/release.asc
EOL

cat > /home/ansible/installpackage.sh << ETL
sudo yum update -y
sudo curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
sudo chmod +x cephadm
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo ./cephadm add-repo --release reef
sudo ./cephadm install
sudo cephadm install ceph-common
ETL

cat > /home/ansible/cephPlaybook.yaml << EOF
- name: set ntp server configuration
  hosts: osds
  tasks:
  - name: Insert block of file in /etc/chrony.conf
    ansible.builtin.blockinfile:
      path: /etc/chrony.conf
      block: |
        server server1 iburst
        server server2 iburst
        server server3 iburst
  - name: restart ntp server
    ansible.builtin.service:
      name: chronyd
      state: restarted
- name: Install ceph package on all server
  hosts: grafanas
  tasks:
   - name: set hostname to grafana
     ansible.builtin.hostname:
       name: grafana
- name: Install ceph package on all server
  hosts: client, osds
  tasks:
  - name: add block text in file
    ansible.builtin.blockinfile:
      path: /etc/chrony.conf
      block: |
        pool 2.centos.pool.ntp.org iburst
        allow 172.31.0.0/16
    when: inventory_hostname == "server1"
  - name: set hostname to server1
    ansible.builtin.hostname:
      name: server1
    when: inventory_hostname == "server1"
  - name: set hostname to server2
    ansible.builtin.hostname:
      name: server2
    when: inventory_hostname == "server2"
  - name: set hostname to server3
    ansible.builtin.hostname:
      name: server3
    when: inventory_hostname == "server3"
  - name: set hostname to client
    ansible.builtin.hostname:
      name: client
    when: inventory_hostname == "client"
  - name: set /etc/hosts on all host
    ansible.builtin.copy:
      src: /etc/hosts
      dest: /etc/hosts
  - name: transfer ceph install script on all server
    ansible.builtin.copy:
      src: installpackage.sh
      dest: /home/ansible/
  - name: install ceph tools on all instance
    ansible.builtin.shell: bash /home/ansible/installpackage.sh
EOF

cat > /home/ansible/cephinstall.yaml << EHT
---
service_type: host
addr: x.x.x.x
hostname: server1
---
service_type: host
addr: x.x.x.x
hostname: server2
---
service_type: host
addr: x.x.x.x
hostname: server3
---
service_type: host
addr: x.x.x.x
hostname: client
---
service_type: host
addr: x.x.x.x
hostname: grafana
---
service_type: mon
placement:
  hosts:
    - server1
    - server2
    - server3
---
service_type: mgr
placement:
  hosts:
    - server1
    - server2
    - server3
---
service_type: osd
service_id: default_drive_group
placement:
  hosts:
    - server1
    - server2
    - server3
data_devices:
  paths:
#In Asia region
#  - /dev/nvme1n1
#  - /dev/nvme2n1
#  - /dev/nvme3n1
# In EU région
  - /dev/xvdg
  - /dev/xvdg
  - /dev/xvdg
---
service_type: grafana
service_name: grafana
placement:
  count: 1
  hosts:
    - grafana
spec:
  initial_admin_password: redhat
  port: 3000
...
EHT

cat > /home/ansible/cephadmin.sh << GTT
sudo cephadm bootstrap                         \
--mon-ip                      x.x.x.x          \
--apply-spec                  cephinstall.yaml \
--ssl-dashboard-port          8443             \
--initial-dashboard-password  ceph             \
--dashboard-password-noupdate                  \
--allow-fqdn-hostname
GTT

cat > /home/ansible/troubleshootingOSD.sh << GTD
ceph orch host add server1
ceph orch host add server2
ceph orch host add server3
ceph orch apply osd --all-available-devices
GTD

sudo chown ansible:ansible /home/ansible/*
sudo chmod +x /home/ansible/cephadmin.sh
sudo chmod +x /home/ansible/troubleshootingOSD.sh
sudo runuser -l ansible -c 'ssh-keygen'



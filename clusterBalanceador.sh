#!/usr/bin/env bash
#apt update && apt upgrade
#apt-get install -y apache2
sudo snap install lxd #--channel=4.0/stable
sleep 5
#vagrnewgrp lxd
gpasswd -a vagrant lxd


#lxd -yes init 
#--network-address=192.168.100.5 --trust-password=admin --storage-backend=dir
cat <<EOF | lxd init --preseed
config:
  core.https_address: 192.168.100.5:8443
  core.trust_password: admin
networks:
- config:
    bridge.mode: fan
    fan.underlay_subnet: 192.168.100.0/24
  description: ""
  name: lxdfan0
  type: ""
  project: default
storage_pools:
- config: {}
  description: ""
  name: local
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdfan0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: default
cluster:
  server_name: vmBalanceador
  enabled: true
  member_config: []
  cluster_address: ""
  cluster_certificate: ""
  server_address: ""
  cluster_password: ""
EOF

sudo cp /var/snap/lxd/common/lxd/server.crt /home/vagrant

sudo cp /home/vagrant/server.crt /vagrant




#!/usr/bin/env bash
#apt update && apt upgrade
#apt-get install -y apache2
sudo snap install lxd #--channel=4.0/stable
sleep 5
#vagrnewgrp lxd
sudo gpasswd -a vagrant lxd

sudo cp /vagrant/server.crt /home/vagrant

touch /home/vagrant/cluster1cfg.yaml
cat <<TEST> /home/vagrant/cluster1cfg.yaml
config: {}
networks: []
storage_pools: []
profiles: []
cluster:
  server_name: vmServidor1
  enabled: true
  member_config:
  - entity: storage-pool
    name: local
    key: source
    value: ""
    description: '"source" property for storage pool "local"'
  cluster_address: 192.168.100.5:8443
  cluster_certificate: |
  server_address: 192.168.100.6:8443
  cluster_password: admin
TEST

sed 's/^/    /g' server.crt > serverm1.crt

sed -i 15r<(sed '1,14!d' serverm1.crt) cluster1cfg.yaml

cat cluster1cfg.yaml | lxd init --preseed






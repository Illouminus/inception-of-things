#!/bin/bash
set -e

GREEN="\033[0;32m"
RESET="\033[0m"

echo -e "${GREEN}Installing K3s server...${RESET}"

curl -sfL https://get.k3s.io | \
  INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --node-name=ebaillotS --flannel-iface=eth1" \
  sh -

# Не ждём узлы — просто даём время системе
sleep 10

mkdir -p /vagrant/shared

cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/node-token
chmod 644 /vagrant/shared/node-token

cp /etc/rancher/k3s/k3s.yaml /vagrant/shared/k3s.yaml
chmod 644 /vagrant/shared/k3s.yaml

echo -e "${GREEN}✅ Token and kubeconfig copied to shared folder.${RESET}"

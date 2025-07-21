#!/bin/bash
set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${GREEN}[INFO] Installing K3s server...${RESET}"

export INSTALL_K3S_EXEC="--node-ip=192.168.56.110 \
  --node-name=ebaillotS \
  --flannel-iface=eth1 \
  --write-kubeconfig-mode=644 \
  --tls-san=192.168.56.110"

if curl -sfL https://get.k3s.io | sh -; then
  echo -e "${GREEN}[SUCCESS] K3s server installed.${RESET}"
else
  echo -e "${RED}[ERROR] Failed to install K3s server.${RESET}"
  exit 1
fi

echo -e "${GREEN}[INFO] Waiting for Kubernetes API to be ready...${RESET}"
until sudo k3s kubectl get nodes &> /dev/null; do
  sleep 3
done
echo -e "${GREEN}[SUCCESS] Kubernetes API is ready.${RESET}"

# Share token and config with agent node
mkdir -p /vagrant/shared
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/node-token
sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/shared/k3s.yaml
sudo chmod 644 /vagrant/shared/node-token /vagrant/shared/k3s.yaml
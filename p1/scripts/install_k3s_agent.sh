#!/bin/bash
set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${GREEN}[INFO] Waiting for K3s server to be reachable...${RESET}"
until nc -zv 192.168.56.110 6443 &> /dev/null; do
  echo -e "${GREEN}[WAIT] Still waiting for server on 192.168.56.110:6443...${RESET}"
  sleep 5
done
echo -e "${GREEN}[INFO] Server is reachable.${RESET}"

echo -e "${GREEN}[INFO] Waiting for node-token...${RESET}"
while [ ! -f /vagrant/shared/node-token ]; do
  echo -e "${GREEN}[WAIT] Waiting for /vagrant/shared/node-token...${RESET}"
  sleep 5
done
NODE_TOKEN=$(cat /vagrant/shared/node-token)

if [ -z "$NODE_TOKEN" ]; then
  echo -e "${RED}[ERROR] Token is empty!${RESET}"
  exit 1
fi

echo -e "${GREEN}[INFO] Installing K3s agent...${RESET}"
curl -sfL https://get.k3s.io | \
  K3S_URL="https://192.168.56.110:6443" \
  K3S_TOKEN="$NODE_TOKEN" \
  INSTALL_K3S_EXEC="--node-ip=192.168.56.111 --node-name=ebaillotSW --flannel-iface=eth1" \
  sh -

echo -e "${GREEN}[SUCCESS] K3s agent installed.${RESET}"

#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN}=== Installing K3s Worker Node ===${RESET}"

# Add dummy eth1 interface (needed for Flannel)
echo -e "${GREEN}Creating dummy interface eth1...${RESET}"
sudo ip link add eth1 type dummy
sudo ip addr add 192.168.56.111/24 dev eth1
sudo ip link set eth1 up

# Wait for token from server
TOKEN_FILE="/vagrant/token.env"
echo -e "${GREEN}Waiting for token at $TOKEN_FILE...${RESET}"
while [ ! -f "$TOKEN_FILE" ]; do
  echo -e "${GREEN}Still waiting for token...${RESET}"
  sleep 5
done

NODE_TOKEN=$(cat "$TOKEN_FILE")
if [ -z "$NODE_TOKEN" ]; then
  echo -e "${RED}ERROR: Token is empty${RESET}"
  exit 1
fi

# Set agent options
export INSTALL_K3S_EXEC="agent \
--server https://192.168.56.110:6443 \
--token $NODE_TOKEN \
--node-ip=192.168.56.111"

# Install K3s
if curl -sfL https://get.k3s.io | sh -; then
  echo -e "${GREEN}K3s Worker installation SUCCESSFUL${RESET}"
else
  echo -e "${RED}K3s Worker installation FAILED${RESET}"
  exit 1
fi
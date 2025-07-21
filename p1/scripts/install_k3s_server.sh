#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN}=== Installing K3s Server Node ===${RESET}"

# Set required K3s flags
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 \
--tls-san ebaillotS \
--node-ip=192.168.56.110 \
--bind-address=192.168.56.110 \
--advertise-address=192.168.56.110"

# Add dummy eth1 interface (needed for Flannel)
echo -e "${GREEN}Creating dummy interface eth1...${RESET}"
sudo ip link add eth1 type dummy
sudo ip addr add 192.168.56.110/24 dev eth1
sudo ip link set eth1 up

# Install K3s
if curl -sfL https://get.k3s.io | sh -; then
  echo -e "${GREEN}K3s Server installation SUCCESSFUL${RESET}"
else
  echo -e "${RED}K3s Server installation FAILED${RESET}"
  exit 1
fi

# Wait for Kubernetes API to be ready
echo -e "${GREEN}Waiting for Kubernetes to be ready...${RESET}"
until sudo k3s kubectl get nodes &>/dev/null; do
  echo -e "${GREEN}Still waiting...${RESET}"
  sleep 5
done

# Copy the node token for worker access
TOKEN_PATH="/var/lib/rancher/k3s/server/node-token"
DEST="/vagrant/token.env"
if sudo cp "$TOKEN_PATH" "$DEST"; then
  echo -e "${GREEN}Token saved to $DEST${RESET}"
  sudo chmod 644 "$DEST"
else
  echo -e "${RED}Failed to save token${RESET}"
  exit 1
fi

# Copy kubeconfig for local testing (optional)
if sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/k3s.yaml; then
  sudo chmod 644 /vagrant/k3s.yaml
  echo -e "${GREEN}k3s.yaml saved to /vagrant${RESET}"
fi

# Show cluster status
echo -e "${GREEN}Cluster nodes:${RESET}"
sudo k3s kubectl get nodes
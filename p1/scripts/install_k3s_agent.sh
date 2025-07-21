#!/bin/bash

set -e  # Exit on any error

# First, ensure the node token is available
echo "Waiting for node token to be available..."
while [ ! -f /vagrant/shared/node-token ]; do
    echo "Still waiting for node token..."
    sleep 5
done

# Read the node token
NODE_TOKEN=$(cat /vagrant/shared/node-token)

if [ -z "$NODE_TOKEN" ]; then
    echo "Error: Node token is empty!"
    exit 1
fi

echo "Node token found, installing k3s agent..."

# Install k3s in agent mode
curl -sfL https://get.k3s.io | \
  K3S_URL="https://192.168.56.110:6443" \
  K3S_TOKEN="$NODE_TOKEN" \
  INSTALL_K3S_EXEC="--node-ip=192.168.56.111 --node-name=ebaillotSW --flannel-iface=eth1" \
  sh -

echo "K3s agent installation completed successfully!"
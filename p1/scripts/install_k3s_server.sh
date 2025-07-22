#!/bin/bash

# Install k3s in server mode
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --node-name=ebaillotS --flannel-iface=eth1" sh -

# Wait for k3s to be ready and generate node token 
until sudo k3s kubectl get nodes; do
    echo "Waiting for k3s to be ready..."
    sleep 5
done

# Create a directory for the node token
mkdir -p /vagrant/shared

# Copy the node token to the shared directory
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/node-token

# Ensure the node token is readable
sudo chmod 644 /vagrant/shared/node-token

# Copy the kubeconfig file to the shared directory
sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/shared/k3s.yaml

# Ensure the kubeconfig file is readable
sudo chmod 644 /vagrant/shared/k3s.yaml

# Check k3s status
sudo k3s kubectl get nodes
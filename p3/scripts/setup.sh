#!/bin/bash

# Stop if error
set -e

# Updating packages
echo "=== Updating packages ==="
sudo apt update
sudo apt upgrade

# Installing required packages

echo "=== STEP 1 ==="
echo "Docker installation"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo usermod -aG docker $(whoami)

echo "=== STEP 2 ==="

echo "Installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "Validate binary"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "Check file integrity"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
echo "Make kubectl executable and accessible"
chmod +x kubectl &&  mv ./kubectl /usr/local/bin


echo "=== STEP 3 ==="
echo "Installing k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


echo "Installing the auto-completion scripts for k3d"
echo "source <(k3d completion bash)" >> ~/.bashrc

echo "..::OK::.."


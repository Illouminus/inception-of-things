#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Updating apt..."
sudo apt-get update -y

echo "[2/4] Installing Docker..."
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Docker repo key
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Allow current user to run docker without sudo
sudo usermod -aG docker "$USER"

echo "[3/4] Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
  https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

echo "[4/4] Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "✅ Installation finished. Log out and log back in so docker group takes effect."

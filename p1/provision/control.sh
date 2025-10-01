#!/usr/bin/env bash
set -euo pipefail

# These are provided by Vagrantfile via the 'env' option (no external exports needed).
: "${K3S_TOKEN:?K3S_TOKEN is required}"
: "${NODE_IP:?NODE_IP is required}"

# Download the k3s installer with retries to survive transient network hiccups.
for i in {1..5}; do
  if curl -fsSL --connect-timeout 20 --retry 5 --retry-delay 5 https://get.k3s.io -o /tmp/install_k3s.sh; then
    break
  fi
  echo "curl get.k3s.io failed (try $i) — retrying..." >&2
  sleep 5
done

# Run the installer. We pass env only to THIS process (no global exports).
# --node-ip sets the advertised IP for the API; --write-kubeconfig-mode 644
# makes the kubeconfig world-readable in case you want to copy it out.
INSTALL_K3S_EXEC="server --node-ip ${NODE_IP} --write-kubeconfig-mode 644" \
K3S_TOKEN="${K3S_TOKEN}" \
  sudo -E sh /tmp/install_k3s.sh

# Prepare kubeconfig for the 'vagrant' user so 'kubectl' works immediately on the server.
mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# Also drop a host-usable kubeconfig into the shared folder,
# and replace 127.0.0.1 with the server's host-only IP so it’s reachable from the host.
mkdir -p /vagrant/shared
sudo sed "s/127.0.0.1/${NODE_IP}/" /etc/rancher/k3s/k3s.yaml > /vagrant/shared/kubeconfig

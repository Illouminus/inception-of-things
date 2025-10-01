#!/usr/bin/env bash
set -euo pipefail

# Provided by Vagrantfile for the agent node.
: "${K3S_TOKEN:?K3S_TOKEN is required}"
: "${NODE_IP:?NODE_IP is required}"
: "${SERVER_IP:?SERVER_IP is required}"

# Fetch the installer with retries.
for i in {1..5}; do
  if curl -fsSL --connect-timeout 20 --retry 5 --retry-delay 5 https://get.k3s.io -o /tmp/install_k3s.sh; then
    break
  fi
  echo "curl get.k3s.io failed (try $i) — retrying..." >&2
  sleep 5
done

# Join this node as an agent (worker) to the control-plane.
# K3S_URL must point to the server API; node-ip advertises this node's IP.
K3S_URL="https://${SERVER_IP}:6443" \
INSTALL_K3S_EXEC="agent --node-ip ${NODE_IP}" \
K3S_TOKEN="${K3S_TOKEN}" \
  sudo -E sh /tmp/install_k3s.sh

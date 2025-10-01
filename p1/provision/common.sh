#!/usr/bin/env bash
set -euo pipefail

# Generic packages and OS tweaks for both nodes.
# - curl: used to fetch the k3s installer
# - ca-certificates: TLS roots for HTTPS
sudo apt-get update -y
sudo apt-get install -y curl ca-certificates

# Kubernetes assumes swap is off; k3s will complain if swap is enabled.
sudo swapoff -a || true

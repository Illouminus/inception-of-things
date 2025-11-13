#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="iot-cluster"

echo "[1/3] Checking if cluster ${CLUSTER_NAME} already exists..."
if k3d cluster list | grep -q "^${CLUSTER_NAME}"; then
  echo "Cluster ${CLUSTER_NAME} already exists. Nothing to do."
  exit 0
fi

echo "[2/3] Creating k3d cluster ${CLUSTER_NAME}..."
k3d cluster create "${CLUSTER_NAME}" \
  --servers 1 \
  --agents 1 \
  --port "8888:30080@loadbalancer" \
  --port "8080:30081@loadbalancer" \
  --wait

echo "[3/3] Verifying cluster..."
kubectl cluster-info
kubectl get nodes -o wide

echo "✅ k3d cluster '${CLUSTER_NAME}' is up."
echo "  - App will later be on http://localhost:8888 (NodePort 30080)."
echo "  - Argo CD UI will later be on http://localhost:8080 (NodePort 30081)."

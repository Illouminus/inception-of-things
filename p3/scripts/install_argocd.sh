#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Creating argocd namespace (if not exists)..."
kubectl apply -f configurations/namespaces/argocd-namespace.yaml

echo "[2/4] Installing Argo CD in 'argocd' namespace..."
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "[3/4] Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

echo "[4/4] Exposing Argo CD server via NodePort 30081..."
kubectl patch svc argocd-server -n argocd \
  -p '{
    "spec": {
      "type": "NodePort",
      "ports": [
        {
          "port": 80,
          "targetPort": 8080,
          "nodePort": 30081,
          "protocol": "TCP",
          "name": "http"
        }
      ]
    }
  }'

echo "✅ Argo CD installed."
echo "UI should be available at: http://localhost:8080"

#!/bin/bash

# Stop if error
set -e

# Updating packages
echo "=== Mise à jour des dépôts ==="
sudo apt update
sudo apt upgrade

# Installing required packages

echo "=== Installation de Docker ==="


echo "=== Installation de kubectl ==="


echo "=== Installation de k3d ==="

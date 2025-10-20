#!/bin/bash

# Stop if error
set -e

# Updating packages
echo "=== Mise à jour des dépôts ==="
sudo apt update

# Installing required packages
echo "=== Installation du serveur OpenSSH ==="
sudo apt install openssh-server ansible git -y


SSHD_CONFIG="/etc/ssh/sshd_config"

# Configfuring port
echo "=== Configuration du fichier sshd_config ==="
sudo nano /etc/ssh/sshd_config

# Saving existing file
if [ -f "$SSHD_CONFIG" ]; then
    cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak_$(date +%Y%m%d_%H%M%S)"
fi

# Deleting old lines to prevent duplicates
sed -i '/^Port /d' "$SSHD_CONFIG"

# Adding our config
{
    echo ""
    echo "# Configuration personnalisée ajoutée par install_ssh_dualport.sh"
    echo "Port 4242"
    echo "PermitRootLogin no"
    echo "PasswordAuthentication yes"
} >> "$SSHD_CONFIG"

# Restart SSH
echo "=== Redémarrage du service SSH ==="
sudo service ssh restart

#Check SSH ports
echo "=== Vérification des ports SSH ==="
ss -tlnp | grep sshd || netstat -tlnp | grep sshd || echo "Aucun port SSH détecté (à vérifier)."

# Check Ansible
if ansible --version >/dev/null 2>&1; then
    echo "✅ Ansible installed."
else
    echo "⚠️ Ansible not installed."
fi


#Check git
if git --version >/dev/null 2>&1; then
    echo "✅ Git installé avec succès."
else
    echo "⚠️ Git semble ne pas être installé correctement."
fi





#!/usr/bin/env bash
set -euo pipefail

echo "Enabling services..."
systemctl enable NetworkManager cups avahi-daemon acpid

# Enabling and setting up firewall
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

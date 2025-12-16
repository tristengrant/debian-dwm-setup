#!/usr/bin/env bash
set -euo pipefail

# Root-level tasks
sudo ./root/install-packages-laptop.sh
sudo ./root/create-groups.sh
sudo ./root/enable-services.sh

# User-level tasks
./user/dotfiles-laptop.sh
./user/suckless.sh
./user/dwmblocks-laptop.sh

sudo chown -R tristen:tristen /home/tristen/*

sudo sensors-detect

echo "Setup complete! Reboot the computer."

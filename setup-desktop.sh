#!/usr/bin/env bash
set -euo pipefail

# Root-level tasks
sudo ./root/install-packages-desktop.sh
sudo ./root/create-groups.sh
sudo ./root/enable-services.sh
sudo ./root/mount-music.sh

# User-level tasks
./user/dotfiles-desktop.sh
./user/suckless.sh
./user/dwmblocks-desktop.sh

sudo chown -R tristen:tristen /home/tristen/*

sudo sensors-detect

echo "Setup complete! Reboot the computer."

#!/usr/bin/env bash
set -euo pipefail

USER="tristen"
HOME_DIR="/home/$USER"

echo "Making home directories..."
mkdir -p "$HOME_DIR/.config"
mkdir -p "$HOME_DIR/Documents"
mkdir -p "$HOME_DIR/Documents/notes"
mkdir -p "$HOME_DIR/Downloads"
mkdir -p "$HOME_DIR/Music"
mkdir -p "$HOME_DIR/Pictures"
mkdir -p "$HOME_DIR/Pictures/screenshots"
mkdir -p "$HOME_DIR/Videos"
mkdir -p "$HOME_DIR/Projects"
mkdir -p "$HOME_DIR/Applications"
mkdir -p "$HOME_DIR/.local/bin"
mkdir -p "$HOME_DIR/.local/share/applications"
mkdir -p "$HOME_DIR/.local/state"

echo "Cloning dotfiles..."
cd "$HOME_DIR/Projects"
[ -d "$HOME_DIR/Projects/dotfiles" ] || git clone https://github.com/tristengrant/dotfiles.git

echo "Cloning scripts repo..."
cd "$HOME_DIR/Projects"
[ -d "$HOME_DIR/Projects/scripts" ] || git clone https://github.com/tristengrant/scripts.git

echo "Symlinking dotfiles..."
cd "$HOME_DIR/Projects/scripts"
./desktop_symlink_dotfiles

source /home/tristen/.bashrc
chmod +x /home/tristen/.xinitrc

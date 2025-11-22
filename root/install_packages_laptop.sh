#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Warning: Error on line $LINENO"; exit 1' ERR
export DEBIAN_FRONTEND=noninteractive

apt update -y
apt install -y curl gpg

echo "Adding mainline Firefox to sources list..."
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

cat <<EOF | tee /etc/apt/sources.list.d/mozilla.sources
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | tee /etc/apt/preferences.d/mozilla

echo "Adding Yazi to the sources list..."
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | tee /etc/apt/sources.list.d/debian.griffo.io.list

dpkg --add-architecture i386
apt update -y
apt upgrade -y

echo "Installing essential system packages..."

BASE_PKGS=(xorg xorg-dev xinit xbindkeys xcape xinput xauth build-essential sxhkd xdotool dbus-x11 libnotify-bin libnotify-dev libusb-0.1-4 xserver-xorg-input-all libx11-dev libxft-dev libxinerama-dev libxrandr-dev libx11-xcb-dev libxext-dev libxcb1-dev libxcb-util0-dev libxcb-keysyms1-dev libxcb-randr0-dev libqt5xml5t64 libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-res0-dev mesa-utils x11-xserver-utils xclip xdg-utils brightnessctl brightness-udev network-manager-gnome dnsutils openssh-client openssh-server sshfs ncdu syncthing pipewire pipewire-audio pipewire-pulse wireplumber pavucontrol dunst pamixer cups-browsed feh rtkit thunar thunar-archive-plugin thunar-volman lm-sensors gvfs-backends gvfs-common dialog mtools cups printer-driver-cups-pdf printer-driver-brlaser system-config-printer unar unzip picom tar gzip zip avahi-daemon acpi acpid flameshot qimgv xdg-user-dirs-gtk fd-find zoxide smartmontools arandr suckless-tools htop lxappearance nano orchis-gtk-theme adwaita-qt wget cmake meson ninja-build pkg-config python3 python-is-python3 npm node-copy-paste firefox firefox-l10n-en-ca lsb-release lxpolkit fonts-recommended fonts-noto-core fonts-noto-mono fonts-noto-color-emoji fonts-jetbrains-mono fonts-font-awesome okular gimp steam-installer qt5ct geany gnome-disk-utility j4-dmenu-desktop kitty tumbler tumbler-plugins-extra ffmpegthumbnailer yazi)

apt install -y "${BASE_PKGS[@]}" || echo "WARNING: Some packages could not be installed."

echo "Refreshing font cache..."
fc-cache -fv

echo "Install NPM packages for coding..."
npm install -g prettier stylelint typescript typescript-language-server vscode-langservers-extracted bash-language-server yaml-language-server

echo "Cleaning up..."
apt autoremove -y
apt clean
apt-get check

echo "Package installation complete!"

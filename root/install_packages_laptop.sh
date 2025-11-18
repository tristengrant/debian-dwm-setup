#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Warning: Error on line $LINENO"; exit 1' ERR
export DEBIAN_FRONTEND=noninteractive

apt install -y curl gpg

echo "Adding Yazi to the sources list..."
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | tee /etc/apt/sources.list.d/debian.griffo.io.list

dpkg --add-architecture i386
apt update -y
apt upgrade -y

echo "Installing essential system packages..."

BASE_PKGS=(xorg xorg-dev xinit xbindkeys xinput xauth build-essential sxhkd xdotool dbus-x11 libnotify-bin libnotify-dev libusb-0.1-4 libwacom-common xserver-xorg-input-wacom xserver-xorg-input-all libx11-dev libxft-dev libxinerama-dev libxrandr-dev libx11-xcb-dev libxext-dev libxcb1-dev libxcb-util0-dev libxcb-keysyms1-dev libxcb-randr0-dev libqt5xml5t64 libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-res0-dev mesa-utils x11-xserver-utils xclip xdg-utils brightnessctl brightness-udev network-manager-gnome network-manager-applet dnsutils jmtpfs openssh-client openssh-server sshfs cifs-utils smbclient ncdu syncthing pipewire pipewire-audio pipewire-pulse pipewire-alsa pipewire-jack wireplumber alsa-utils pavucontrol pulsemixer dunst pamixer cups-browsed mpd mpc ncmpcpp feh rtkit thunar thunar-archive-plugin thunar-volman lm-sensors gvfs-backends gvfs-common dialog mtools cups printer-driver-cups-pdf printer-driver-brlaser system-config-printer unar unzip tar gzip zip udiskie avahi-daemon acpi acpid flameshot qimgv xdg-user-dirs-gtk fd-find zoxide smartmontools arandr autorandr suckless-tools htop thermald nano orchis-gtk-theme adwaita-qt wget cmake meson ninja-build pkg-config python3 python-is-python3 npm node-copy-paste firefox-esr playerctl lsb-release lxpolkit fonts-recommended fonts-noto-core fonts-noto-mono fonts-noto-color-emoji fonts-jetbrains-mono fonts-terminus fonts-font-awesome okular gimp steam-installer qt5ct geany gnome-disk-utility j4-dmenu-desktop kitty tumbler tumbler-plugins-extra ffmpegthumbnailer yazi)

apt install -y "${BASE_PKGS[@]}" || echo "WARNING: Some packages could not be installed."

echo "Refreshing font cache..."
fc-cache -fv

echo "Install NPM packages for coding..."
npm install -g prettier stylelint typescript typescript-language-server vscode-langservers-extracted bash-language-server yaml-language-server

echo "Cleaning up..."
apt autoremove -y
apt clean
apt-get check

echo "Installation complete! Reboot to start LightDM and your desktop environment."

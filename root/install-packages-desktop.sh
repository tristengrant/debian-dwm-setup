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

dpkg --add-architecture i386
apt update -y
apt upgrade -y

echo "Installing essential system packages..."

BACKPORTS_PKGS=(linux-image-amd64 firmware-amd-graphics amd64-microcode)

BASE_PKGS=(xorg xorg-dev xinit xinput xauth dbus-x11 xserver-xorg-input-all x11-xserver-utils xdg-utils brightnessctl brightness-udev libnotify-bin libnotify-dev libusb-0.1-4 network-manager-gnome dnsutils gvfs-backends gvfs-common xdg-user-dirs-gtk dialog mtools lsb-release pkg-config)

WM_PKGS=(build-essential libx11-dev libxft-dev libxinerama-dev libxrandr-dev libx11-xcb-dev libxext-dev libxcb1-dev libxcb-util0-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-res0-dev libqt5xml5t64 cmake ninja-build)

IMG_VID_PKGS=(mpv tumbler tumbler-plugins-extra ffmpegthumbnailer scrot)

UTILITY_PKGS=(feh nano dunst openssh-client openssh-server sshfs cifs-utils smbclient xclip xdotool picom python3 python-is-python3 lm_sensors j4-dmenu-desktop htop fd-find arandr autorandr)

FILE_PKGS=(pcmanfm lf syncthing filezilla unar unzip tar gzip zip 7zip)

THEME_PKGS=(breeze-gtk-theme)

FONT_PKGS=(fonts-noto-core fonts-noto-mono fonts-noto-color-emoji fonts-noto-cjk fonts-jetbrains-mono fonts-font-awesome)

BROWSER_PKGS=(firefox firefox-l10n-en-ca)

AUDIOSTACK_PKGS=(pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol rtkit alsa-utils)

DRAWING_PKGS=(scribus gimp inkscape libwacom-common xserver-xorg-input-wacom)

RECORDING_PKGS=(lsp-plugins-vst3 qpwgraph)

AUDIOCTRL_PKGS=(mpd mpc ncmpcpp playerctl)

GAMING_PKGS=(steam-installer)

DEV_PKGS=(fzf jq ripgrep nodejs npm)

PRINTING_PKGS=(cups-filters cups printer-driver-cups-pdf printer-driver-brlaser printer-driver-dymo system-config-printer avahi-daemon glabels)

apt install -y -t trixie-backports "${BACKPORTS_PKGS[@]}" || { echo "WARNING: Some backports packages could not be installed."; true; }

apt install -y "${BASE_PKGS[@]}" || { echo "WARNING: Some base packages could not be installed."; true; }

apt install -y "${WM_PKGS[@]}" || { echo "WARNING: Some window manager packages could not be installed."; true; }

apt install -y "${IMG_VID_PKGS[@]}" || { echo "WARNING: Some image/video packages could not be installed."; true; }

apt install -y "${UTILITY_PKGS[@]}" || { echo "WARNING: Some utility packages could not be installed."; true; }

apt install -y "${FILE_PKGS[@]}" || { echo "WARNING: Some file packages could not be installed."; true; }

apt install -y "${THEME_PKGS[@]}" || { echo "WARNING: Some theme packages could not be installed."; true; }

apt install -y "${FONT_PKGS[@]}" || { echo "WARNING: Some font packages could not be installed."; true; }

apt install -y "${BROWSER_PKGS[@]}" || { echo "WARNING: Some browser packages could not be installed."; true; }

apt install -y "${AUDIOSTACK_PKGS[@]}" || { echo "WARNING: Some audio stack packages could not be installed."; true; }

apt install -y "${DRAWING_PKGS[@]}" || { echo "WARNING: Some drawing packages could not be installed."; true; }

apt install -y "${RECORDING_PKGS[@]}" || { echo "WARNING: Some recording packages could not be installed."; true; }

apt install -y "${AUDIOCTRL_PKGS[@]}" || { echo "WARNING: Some audio control packages could not be installed."; true; }

apt install -y "${GAMING_PKGS[@]}" || { echo "WARNING: Some gaming packages could not be installed."; true; }

apt install -y "${DEV_PKGS[@]}" || { echo "WARNING: Some development packages could not be installed."; true; }

apt install -y "${PRINTING_PKGS[@]}" || { echo "WARNING: Some printing packages could not be installed."; true; }

echo "Refreshing font cache..."
fc-cache -fv

echo "Cleaning up..."
apt autoremove -y
apt clean
apt-get check

echo "Package installation complete!"

# Write manual application installation reminder
USER_NAME="tristen"
USER_HOME="/home/$USER_NAME"
USER_UID=$(id -u "$USER_NAME")
USER_GID=$(id -g "$USER_NAME")

cat <<EOF > "$USER_HOME/README-manually-install.txt"
Remember to manually install:
VCV Rack Pro
Reaper
ReaPack
Hugo
Neovim (AppImage)
Obsidian (AppImage)
Krita (AppImage)
BeeRef (AppImage)
EOF

chown "$USER_UID:$USER_GID" "$USER_HOME/README-manually-install.txt"

#!/usr/bin/env bash
set -euo pipefail

echo "Adding media server musicm..."

# SAMBA SETUP

USER_NAME="tristen"
USER_HOME="/home/$USER_NAME"
CRED_FILE="$USER_HOME/.smbcredentials"
MOUNT_POINT="$USER_HOME/Music"

USER_UID=$(id -u "$USER_NAME")
USER_GID=$(id -g "$USER_NAME")

# Create credentials template if missing
if [[ ! -f "$CRED_FILE" ]]; then
    echo "username=YOUR_USERNAME" > "$CRED_FILE"
    echo "password=YOUR_PASSWORD" >> "$CRED_FILE"
    chmod 600 "$CRED_FILE"
    chown "$USER_UID:$USER_GID" "$CRED_FILE"
    echo "Created $CRED_FILE (edit it to add username/password)"
fi

# Ensure mount directory exists
mkdir -p "$MOUNT_POINT"
chown "$USER_UID:$USER_GID" "$MOUNT_POINT"

# Build fstab entry
FSTAB_ENTRY="//192.168.2.221/Music $MOUNT_POINT cifs credentials=$CRED_FILE,uid=$USER_UID,gid=$USER_GID,file_mode=0644,dir_mode=0755,vers=2.1,sec=ntlmssp 0 0"

# Add to fstab only if absent
if ! grep -Fqx "$FSTAB_ENTRY" /etc/fstab; then
    echo "$FSTAB_ENTRY" >> /etc/fstab
    echo "Added Samba share to /etc/fstab"
else
    echo "Samba fstab entry already exists, skipping."
fi

# Write README reminder
cat <<EOF > "$USER_HOME/README-samba-setup.txt"
Before running 'sudo mount -a', edit the .smbcredentials file at:

  $CRED_FILE

Add:
username=YOUR_USERNAME
password=YOUR_PASSWORD

Then mount using:
  sudo mount -a
EOF

chown "$USER_UID:$USER_GID" "$USER_HOME/README-samba-setup.txt"

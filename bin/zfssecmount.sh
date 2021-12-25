#!/usr/bin/env bash
# Load password for decrypting ZFS secret volumes and mount.
sudo zfs load-key rpool/secret
awk '/noauto/{print $2}' /etc/fstab | xargs -n1 sudo mount
sudo systemctl restart syncthing gitweb

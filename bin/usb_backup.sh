#!/usr/bin/env bash

set -e

ASSETS=(
    "/mnt/melchior/git"
    "${HOME}/.password-store"
    "${HOME}/.gnupg"
    "${HOME}/.ssh"
)

DEVICE_PATH="/dev/disk/by-label"
DEVICE_LABEL="KEYCHAIN_EXTRA"
DEVICE="${DEVICE_PATH}/${DEVICE_LABEL}"
DEST="/mnt/plugged"

echo "Mounting device: ${DEVICE} -> ${DEST}"
sudo umount "${DEST}" 2>/dev/null | echo
sudo mount "${DEVICE}" "${DEST}"

remove_dot() {
    echo "$1" | sed 's/^\.//'
}

for ASSET in ${ASSETS[@]}; do
    NAME=$(basename ${ASSET})
    TARGET="${DEST}/$(remove_dot ${NAME})"
    echo "* Copying: ${ASSET} -> ${TARGET}"
    sudo rsync -qr "${ASSET}" "${TARGET}"
done

echo
echo "Syncing..."
sync

echo "Removing device..."
sudo umount -f "${DEST}"

echo "SUCCESS!"

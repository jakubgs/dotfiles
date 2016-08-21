#!/usr/bin/env bash

set -e

ASSETS=(
    "/mnt/melchior/git"
    "/mnt/melchior/secret"
    "/mnt/melchior/data/Work"
    "${HOME}/.password-store"
    "${HOME}/.gnupg"
    "${HOME}/.ssh"
)

DEVICE_PATH="/dev/disk/by-label"
DEVICE_LABEL="KEYCHAIN"
DEVICE="${DEVICE_PATH}/${DEVICE_LABEL}"
DEST="/mnt/keychain"

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
    sudo rsync --delete -aqr "${ASSET}" "${TARGET}"
done

echo
echo "Syncing..."
sync

if [[ $1 == '-u' ]]; then
    exit 0
fi
echo "Removing device..."
sudo umount -f "${DEST}"

echo "SUCCESS!"

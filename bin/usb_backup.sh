#!/usr/bin/env bash

set -e

USERNAME=sochan
ASSETS=(
    "/home/$USERNAME/.password-store"
    "/home/$USERNAME/.gnupg"
    "/home/$USERNAME/.ssh"
    "/mnt/melchior/git"
    "/mnt/melchior/secret"
    "/mnt/melchior/data/Docs"
    "/mnt/melchior/data/Photos"
    "/mnt/melchior/data/Important"
)

DEVICE="$1"
LABEL="keychain"
DEST="/mnt/${LABEL}"

PASS_FILE="/home/${USERNAME}/.usb_backup_pass"

if [[ $UID -ne 0 ]]; then
    echo "ERROR: This script requires root piviliges!"
    exit 1
fi

if [[ $1 == '-c' ]]; then
    DEVICE="$2"
    read -p "Are you sure you want to format ${DEV} ? <y/N> " prompt
    if [[ $prompt =~ [yY](es)* ]]; then
        cryptsetup luksFormat -d "${PASS_FILE}" -q -y -v "${DEVICE}" && \
        cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}" && \
        mkfs.ext4 -m 0 -L "${LABEL}" "/dev/mapper/${LABEL}" && \
        cryptsetup luksClose "${LABEL}"
    fi
    exit 0
fi

echo "Mounting device: ${DEVICE} -> ${DEST}"
umount "${DEST}" 2>/dev/null | echo
# decrypt
cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}"
DEVICE="/dev/mapper/${LABEL}"
mount "${DEVICE}" "${DEST}"
# unmount on exit
function cleanup {
    if [[ $1 == '-u' ]]; then
        exit 0
    fi
    echo "Removing device..."
    umount -f "${DEST}"
    cryptsetup luksClose "${LABEL}"
}

trap cleanup EXIT

remove_dot() {
    echo "$1" | sed 's/^\.//'
}

for ASSET in ${ASSETS[@]}; do
    NAME=$(basename ${ASSET})
    TARGET="${DEST}/$(remove_dot ${NAME})"
    FREE=$(df ${DEST} | awk '/dev/{print $4}')
    SIZE_NOW=$(du -sb "${ASSET}"  | cut -f1)
    SIZE_OLD=0
    if [[ -d "${TARGET}" ]]; then
        SIZE_OLD=$(du -sb "${TARGET}" | cut -f1 2>/dev/null)
    fi
    if [[ $FREE -gt $(($SIZE_NEW-$SIZE_OLD)) ]]; then
        echo "* Copying: ${ASSET} -> ${TARGET} ($((${SIZE_NOW}/1024)) KBytes)"
        rsync --delete -aqr "${ASSET}" "${TARGET}"
    else
        echo "* Skipping: ${ASSET} - Not enough space."
    fi
done

echo
echo "Syncing..."
sync

df -h "${DEVICE}"

echo "SUCCESS!"

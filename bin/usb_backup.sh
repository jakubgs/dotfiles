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
    "/mnt/melchior/data/Important"
    "/mnt/melchior/data/Photos"
)

DEVICE="$1"
LABEL="keychain"
DEST="/mnt/${LABEL}"

PASS_FILE="/home/${USERNAME}/.usb_backup_pass"

function usage {
  cat << EOF
Usage: usb_backup.sh [-f] /dev/sdx"

 -f - Format specified defice for secret backups.

Backups password file: ${PASS_FILE}
EOF
}

if [[ $UID -ne 0 ]]; then
    echo "ERROR: This script requires root piviliges!"
    exit 1
fi

if [[ $1 == '' ]]; then
  echo "ERROR: You have to specify a device name as first argument!"
  echo
  usage
  echo
  echo "Here are some options:"
  lsblk -S
  exit 1
fi

if [[ $1 == '-c' ]]; then
    DEVICE="$2"
    read -p "Are you sure you want to format ${DEV} ? <y/N> " prompt
    if [[ $prompt =~ [yY](es)* ]]; then
        cryptsetup luksFormat -d "${PASS_FILE}" -q -y -v "${DEVICE}" && \
        cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}" && \
        mkfs.ext4 -m 0 -L "${LABEL}" "/dev/mapper/${LABEL}" && \
        sync && sleep 2
        cryptsetup luksClose "${LABEL}"
    fi
    exit 0
fi

echo "Mounting device: ${DEVICE} -> ${DEST}"
umount "${DEST}" 2>/dev/null | echo
# decrypt
cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}"
DEVICE="/dev/mapper/${LABEL}"
mkdir -p "${DEST}"
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

check_size() {
    ASSET=$1
    TARGET=$2
    SIZE_NOW=$(du -sb "${ASSET}" | cut -f1)
    SIZE_OLD=0
    if [[ -d "${TARGET}" ]]; then
        SIZE_OLD=$(du -sb "${TARGET}" | cut -f1 2>/dev/null)
    fi
    echo $(($SIZE_NOW-$SIZE_OLD))
}

for ASSET in ${ASSETS[@]}; do
    NAME=$(basename ${ASSET})
    TARGET="${DEST}/$(remove_dot ${NAME})"
    FREE=$(df ${DEST} | awk '/dev/{print $4}')
    SIZE=$(check_size "$ASSET" "$TARGET")
    if [[ $FREE -lt $SIZE ]]; then
        echo "* Skipping: ${ASSET} - Not enough space. ($((${SIZE}/1024)) KBytes)"
        continue
    fi
    echo "* Copying: ${ASSET} -> ${TARGET} ($((${SIZE}/1024)) KBytes)"
    rsync --delete -aqr "${ASSET}" "${TARGET}"
done

echo
echo "Syncing..."
sync

df -h "${DEVICE}"

echo "SUCCESS!"

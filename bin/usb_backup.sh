#!/usr/bin/env bash

set -e

USERNAME=sochan
ASSETS=(
    "/home/$USERNAME/.password-store"
    "/home/$USERNAME/.gnupg"
    "/home/$USERNAME/.ssh"
    "/mnt/melchior/git"
    "/mnt/melchior/data/docs"
    "/mnt/melchior/data/company"
    "/mnt/melchior/data/important"
    "/mnt/melchior/data/photos"
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

if [[ ! -e "${PASS_FILE}" ]]; then
    echo -n "Provide password: "
    read -s PASSWORD
    echo
    echo "${PASSWORD}" > "${PASS_FILE}"
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
    set +x
    du -hsc ${DEST}/*
    df -h "${DEVICE}"
    echo
    echo "Removing device..."
    umount -f "${DEST}"
    cryptsetup luksClose "${LABEL}"
}

trap cleanup EXIT ERR INT QUIT

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
    REMAINING_SIZE=$(($SIZE_NOW - $SIZE_OLD))
    echo "${REMAINING_SIZE}"
}

for ASSET in ${ASSETS[@]}; do
    NAME=$(basename ${ASSET})
    TARGET="${DEST}/$(remove_dot ${NAME})"
    FREE_B=$(df -P ${DEST} | awk '/dev/{print ($4 * 1024)}')
    SIZE_B=$(check_size "$ASSET" "$TARGET")
    LEFT_B=$((${SIZE_B} / 1024))
    if [[ ${SIZE_B} -gt 0 ]] && [[ ${FREE_B} -lt ${SIZE_B} ]]; then
        echo "* Skipping: ${ASSET} - Not enough space. (${LEFT_B} KBytes)"
        continue
    fi
    echo "* Copying: ${ASSET} -> ${TARGET} (${LEFT_B} KBytes)"
    rsync --delete -aqr "${ASSET}" "${TARGET}"
done

echo
echo "Syncing..."
sync

echo "SUCCESS!"

#!/usr/bin/env bash
set -e

function show_help() {
  cat << EOF
Usage: usb_backup.sh [-f|-s|-n|-h] [-l joe] -d /dev/sdx"

 -h - Show this help message.
 -d - Specify device name.
 -l - Specify label for LUKS device.
 -u - Specify username for home dir.
 -f - Format specified defice for secret backups.
 -s - Sync pre-defined assets to device.
 -n - Do not mount the device.

EOF
}

function show_devices() {
    echo "Here are some options:"
    lsblk -S
}

function error() {
    echo "ERROR: $1" >&2
    exit 1
}

function cleanup_umount() {
    set +x
    du -hsc "/mnt/${LABEL}/*"
    df -h "${DEVICE}"
    echo
    echo "Removing device..."
    umount -f "/mnt/${LABEL}"
    cryptsetup luksClose "${LABEL}"
}

function remove_dot() {
    echo "$1" | sed 's/^\.//'
}

function check_size() {
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

function format_device() {
    read -p "Are you sure you want to format ${DEV} ? <y/N> " prompt
    if [[ ! $prompt =~ [yY](es)* ]]; then
        exit 0
    fi
    cryptsetup luksFormat -d "${PASS_FILE}" -y -v "${DEVICE}"
    cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}"
    mkfs.ext4 -m 0 -L "${LABEL}" "/dev/mapper/${LABEL}"
    sync && sleep 2
    cryptsetup luksClose "${LABEL}"
}

function mount_device() {
    echo "Mounting device: ${DEVICE} -> /mnt/${LABEL}"
    umount "/mnt/${LABEL}" 2>/dev/null | echo
    # decrypt
    cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}"
    DEVICE="/dev/mapper/${LABEL}"
    mkdir -p "/mnt/${LABEL}"
    mount "${DEVICE}" "/mnt/${LABEL}"
    # unmount on exit
    trap cleanup_umount EXIT ERR INT QUIT
}

function copy_assets() {
    for ASSET in ${ASSETS[@]}; do
        NAME=$(basename ${ASSET})
        TARGET="/mnt/${LABEL}/$(remove_dot ${NAME})"
        FREE_B=$(df -P /mnt/${LABEL} | awk '/dev/{print ($4 * 1024)}')
        SIZE_B=$(check_size "$ASSET" "$TARGET")
        LEFT_B=$((${SIZE_B} / 1024))
        if [[ ${SIZE_B} -gt 0 ]] && [[ ${FREE_B} -lt ${SIZE_B} ]]; then
            echo "* Skipping: ${ASSET} - Not enough space. (${LEFT_B} KBytes)"
            continue
        fi
        echo "* Copying: ${ASSET} -> ${TARGET} (${LEFT_B} KBytes)"
        rsync --delete -aqr "${ASSET}/." "${TARGET}"
    done
    echo "Syncing..."
    sync
}


# Initialize our own variables:
USERNAME='jakubgs'
LABEL="keychain"
MOUNT=1
FORMAT=0
SYNC=0

# Parse arguments
while getopts "hnsfu:d:l:" opt; do
  case "$opt" in
    h) show_help; show_devices; exit 0 ;;
    n) MOUNT=0 ;;
    s) SYNC=1 ;;
    f) FORMAT=1 ;;
    u) USERNAME="${OPTARG}" ;;
    d) DEVICE="${OPTARG}" ;;
    l) LABEL="${OPTARG}" ;;
  esac
done
[ "${1:-}" = "--" ] && shift

# File with decrypting password
PASS_FILE="/home/${USERNAME}/.usb_backup_pass"
# Pre-defined assets to sync
ASSETS=(
    "/home/$USERNAME/.password-store"
    "/home/$USERNAME/.gnupg"
    "/home/$USERNAME/.ssh"
    "/mnt/git"
    "/mnt/data/Documents"
    "/mnt/data/company"
    "/mnt/data/important"
    "/mnt/photos"
)


[[ $UID -ne 0 ]]          && error "This script requires root piviliges!"
[[ -z "${DEVICE}" ]]      && error "No device specified with -d flag!"
[[ -z "${LABEL}" ]]       && error "Label cannot be an empty string!"
[[ ! -f "${PASS_FILE}" ]] && error "No password file found!"

[[ "${FORMAT}" -eq 1 ]] && format_device
[[ "${MOUNT}" -eq 1 ]]  && mount_device
[[ "${SYNC}" -eq 1 ]]   && copy_assets

echo "SUCCESS!"

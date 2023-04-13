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
    echo -e "Here are some options:\n"
    lsblk -S | grep -e VENDOR -e usb
}

function error() {
    echo "ERROR: $1" >&2
}

function bytes_to_mb() {
    [[ "${1}" -lt 0 ]] && echo -n '-'
    numfmt --to iec --format "%.2f" "${1#-}"
}

function cleanup_umount() {
    echo
    du -hsc "/mnt/${LABEL}/"*
    echo
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
    SIZE_NOW=$(du --apparent-size -sb "${ASSET}" | cut -f1)
    SIZE_OLD=0
    if [[ -d "${TARGET}" ]]; then
        SIZE_OLD=$(du --apparent-size -sb "${TARGET}" | cut -f1)
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
    echo "Mounting device: ${DEVICE} -> /dev/mapper/${LABEL} -> /mnt/${LABEL}"
    umount "/mnt/${LABEL}" 2>/dev/null | echo
    # decrypt
    cryptsetup luksOpen -d "${PASS_FILE}" "${DEVICE}" "${LABEL}"
    DEVICE="/dev/mapper/${LABEL}"
    mkdir -p "/mnt/${LABEL}"
    mount "${DEVICE}" "/mnt/${LABEL}"
}

function copy_assets() {
    for ASSET in ${ASSETS[@]}; do
        NAME=$(basename ${ASSET})
        TARGET="/mnt/${LABEL}/$(remove_dot ${NAME})"
        FREE_B=$(df -P /mnt/${LABEL} | awk '/dev/{print ($4 * 1024)}')
        LEFT_B=$(check_size "$ASSET" "$TARGET")
        if [[ ${LEFT_B} -gt 0 ]] && [[ ${FREE_B} -lt ${LEFT_B} ]]; then
            echo "* Skipping: ${ASSET} - Not enough space. ($(bytes_to_mb "${LEFT_B}"))"
            continue
        fi
        echo "* Copying: ${ASSET} -> ${TARGET} ($(bytes_to_mb "${LEFT_B}"))"
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

[[ $UID -ne 0 ]]          && error "This script requires root piviliges!" && exit 1
[[ -z "${DEVICE}" ]]      && error "No device specified with -d flag!" && show_devices && exit 1
[[ -z "${LABEL}" ]]       && error "Label cannot be an empty string!" && exit 1
[[ ! -f "${PASS_FILE}" ]] && error "No password file found!" exit 1

# unmount on exit
trap cleanup_umount EXIT ERR INT QUIT

[[ "${FORMAT}" -eq 1 ]] && format_device
[[ "${MOUNT}" -eq 1 ]]  && mount_device
[[ "${SYNC}" -eq 1 ]]   && copy_assets

echo "SUCCESS!"

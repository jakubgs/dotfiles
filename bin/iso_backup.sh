#!/usr/bin/env bash

set -x

# This script creates an encrypted ISO image for offline backups.
# Source: https://www.frederickding.com/posts/2017/08/luks-encrypted-dvd-bd-data-disc-guide-273316/

if [[ ${UID} -ne 0 ]]; then
    echo "This script needs to be run as root!" >&2
    exit 1
fi

if [[ "${#}" -eq 1 ]] && [[ "${1}" == "-u" ]]; then
    echo "Unmounting..."

fi

if [[ "${#}" -ne 3 ]]; then
    echo "Usage: ${0} <ISO_PATH> <ISO_LABEL> <MOUNT_POINT>" >&2
    exit 1
fi

ISO_SIZE="2530M"
ISO_PATH="${1}"
ISO_LABEL="${2}"
MOUNT_POINT="${3}"
LOOP_DEVICE="/dev/loop${b}"
MAPPER_DEV_NAME="backup"
MAPPER_DEV_PATH="/dev/mapper/${MAPPER_DEV_NAME}"

function _create() {
    set -x
    # Allocate an ISO image file
    truncate -s "${ISO_SIZE}" "${ISO_PATH}"
    # Mount ISO via loopback device
    export LOOP_DEVICE=$(losetup --show -f "${ISO_PATH}")
    # Format with LUKS filesystem
    cryptsetup luksFormat "${LOOP_DEVICE}"
    # Map the new LUKS filesystem to a block device
    cryptsetup luksOpen "${LOOP_DEVICE}" "${MAPPER_DEV_NAME}"
    # Created UDF filesystem on the device
    mkudffs --label="${ISO_LABEL}" "${MAPPER_DEV_PATH}"
}

function _mount() {
    # Mount ISO via loopback device
    export LOOP_DEVICE=$(losetup --show -f "${ISO_PATH}")
    # Map the new LUKS filesystem to a block device
    cryptsetup luksOpen "${LOOP_DEVICE}" "${MAPPER_DEV_NAME}"
    # Mount the filesystem
    mkdir -p "${MOUNT_POINT}"
    mount -t udf "${MAPPER_DEV_PATH}" "${MOUNT_POINT}"
}

function _umount() {
    umount "${MAPPER_DEV_PATH}"
    cryptsetup luksClose "${MAPPER_DEV_NAME}"
    losetup -d "${LOOP_DEVICE}"
}

function _prompt() {
    echo "Have you copied all the necessary files?"
    select yn in "yes" "no"; do
        echo "## ${yn} ##"
        case ${yn} in
            yes) echo "yes"; exit;;
            no) echo "no"; return;;
        esac
    done
}

#trap _umount EXIT ERR INT QUIT

echo "Creating..."

#_create
#_mount
_prompt
#_umount

echo "SUCCESS!"

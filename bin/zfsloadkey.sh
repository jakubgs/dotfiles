#!/usr/bin/env bash
set -Euo pipefail

export GRN='\033[0;32m'
export BLD='\033[1m'
export RST='\033[0m'

# Load password for decrypting ZFS secret volumes and mount.
readarray -t VOLUMES < <(
    zfs get -H encryptionroot -t filesystem | awk '{if($3!="-"){print $3}}' | uniq
)

for VOLUME in "${VOLUMES[@]}"; do
    echo -e "Loading key for: ${GRN}${BLD}${VOLUME}${RST}" >&2
    sudo zfs load-key "${VOLUME}" || continue
    for MOUNT in $(awk '/noauto/{print $2}' /etc/fstab); do
        echo -e "Mounting: ${GRN}${BLD}${MOUNT}${RST}" >&2
        sudo mount "${MOUNT}" &>/dev/null
    done
done

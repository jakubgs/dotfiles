#!/usr/bin/env bash

set -e

if [[ $# -eq 0 ]]; then
    echo "Usage: mkzfsbkp.sh <name> <hdd_dev>" >&2
    exit 1
fi

if [[ "${UID}" -ne 0 ]]; then
    echo "This script needs to run as root!" >&2
    exit 1
fi

zpool create \
    -o comment="Name: ${1}" \
    -O xattr=sa \
    -O compression=off \
    -O acltype=posixacl \
    -O mountpoint=legacy \
    -O copies=2 \
    "${1}" "${2}"

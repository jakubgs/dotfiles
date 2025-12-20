#!/usr/bin/env bash

function mod_date() {
    stat "${1}" | awk '/Modify:/{print $2}'
}

function show_help() {
  cat << EOF
Usage: organizephotos.sh [-p] -d unsorted_photos

 -h - Show this help message.
 -d - Specify directory with photos. Mandatory.
 -p - Parse filenames to extract photo dates.

EOF
}

PARSE_FILENAME=0
REGEX='.*[IMGVD]+_([0-9]{4})([0-9]{2})([0-9]{2})_.*$'
SRC='.'

# Parse arguments
while getopts "hpd:" opt; do
  case "$opt" in
    p) PARSE_FILENAME=1 ;;
    d) SRC="${OPTARG}" ;;
    h) show_help; list_devices; exit 0 ;;
    *) show_help; list_devices; exit 1 ;;
  esac
done
[ "${1:-}" = "--" ] && shift

# If src is not a directory expand it. Might be a glob.
if [[ ! -d "${@}" ]]; then
    SRC=$(echo ${@})
fi

for FILE in ${SRC[@]}; do
    [[ ! -f "${FILE}" ]] && continue

    if [[ ${PARSE_FILENAME} -eq 1 ]] && [[ ${FILE} =~ ${REGEX} ]]; then
        YEAR="${BASH_REMATCH[1]}"
        MONTH="${BASH_REMATCH[2]}"
        DAY="${BASH_REMATCH[3]}"
    else
        DATE=$(mod_date "${FILE}")
        YEAR="${DATE%%-*}"
        DAY="${DATE#"${YEAR}-"}"
        MONTH="${DAY%%-*}"
    fi

    DIR="${YEAR}/${MONTH}"

    if [[ ! -f "${DIR}/${FILE}" ]]; then
        mkdir -p "${DIR}"
        mv -v "${FILE}" "${DIR}/"
    elif cmp --silent "${FILE}" "${DIR}/${FILE}"; then
        echo "Already exists: ${DIR}/${FILE}"
    fi
done

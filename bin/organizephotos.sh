#!/usr/bin/env bash

function mod_date() {
    stat "${1}" | awk '/Modify:/{print $2}'
}

SRC="${1:-.}"

[[ ! -d "${SRC}" ]] && { echo "ERROR: Source not a directory!"; exit 1; }

for FILE in $(ls "${SRC}"); do
    [[ ! -f "${SRC}/${FILE}" ]] && continue

    DATE=$(mod_date "${SRC}/${FILE}")
    YEAR="${DATE%%-*}"
    MONTH_DAY="${DATE#"${YEAR}-"}"
    MONTH="${MONTH_DAY%%-*}"

    DIR="${YEAR}/${MONTH}"

    if [[ ! -f "${DIR}/${FILE}" ]]; then
        mkdir -p "${DIR}"
        mv -v "${SRC}/${FILE}" "${DIR}/"
    elif cmp --silent "${SRC}/${FILE}" "${DIR}/${FILE}"; then
        echo "Already exists: ${DIR}/${FILE}"
    fi
done

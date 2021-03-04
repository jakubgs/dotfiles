#!/usr/bin/env bash

set -e
DIR="${1:-.}"
shift

cd "${DIR}"
for FILE in *.flac *.wav *.wave; do
    echo "Converting: ${FILE} -> ${FILE%.*}.ogg"
    oggenc --discard-comments -Q -q 6 "${@}" "${FILE}"
done

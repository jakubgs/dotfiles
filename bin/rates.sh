#!/usr/bin/env bash
set -eof pipefail

if [[ -z "${FIXER_API_KEY}" ]]; then
    echo "No FIXER_API_KEY variable set!" >&2
    exit 1
fi

API_URL="http://data.fixer.io/api/latest"

BASE=${1:-EUR}
SYMBOLS=${2:-PLN,USD,CHF}

curl -s "${API_URL}?access_key=${FIXER_API_KEY}&base=${BASE}&symbols=${SYMBOLS}" | jq .

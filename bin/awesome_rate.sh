#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
"${SCRIPT_DIR}/rates.sh" | jq -r ".rates | \" EUR-PLN: \" + (.PLN|tostring)"

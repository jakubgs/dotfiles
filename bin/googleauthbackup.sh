#!/usr/bin/env bash

QRS_PATH="./qrs"
SQL_FILE="$1"
if [[ -z "${SQL_FILE}" ]]; then
    echo "No SQL file path provided!" >&2
    exit 1
fi

# Commented out, better done manually
#adb pull /data/data/com.google.android.apps.authenticator2/databases/databases "${DATA}/databases"
echo "select * from accounts;" | sqlite3 -separator ';' "${SQL_FILE}" > "dump.csv"

mkdir -p "${QRS_PATH}"

OLDIFS=$IFS
IFS=";"

while read _ID EMAIL SECRET COUNTER TYPE PROVIDER ISSUER ORIGINAL_NAME; do
	URL="otpauth://totp/${EMAIL}?secret=${SECRET}&issuer=${ISSUER}"
    URL=$(echo "${URL}" | sed 's/ /%20/')
    IMG="${QRS_PATH}/${_ID}.png"
    printf "* Gen: %50s -->> %s\n" ${EMAIL} ${IMG}
    qrencode -s 20 -o "${IMG}" "${URL}"
done < "./dump.csv"
IFS=$OLDIFS

feh -r "${QRS_PATH}"

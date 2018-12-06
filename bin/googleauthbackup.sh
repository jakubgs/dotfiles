#!/usr/bin/env bash

DATA=/tmp/goauth/data
QRS=/tmp/goauth/qrs

mkdir -p "${DATA}" "${QRS}"
# Commented out, better done manually
#adb pull /data/data/com.google.android.apps.authenticator2/databases/databases "${DATA}/databases"
#echo ".schema accounts" | sqlite3 ./data/databases > "${DATA}/schema.txt
echo "select * from accounts;" | sqlite3 -separator ';' "${DATA}/databases" > "${DATA}/dump.csv"

OLDIFS=$IFS
IFS=";"

while read _ID EMAIL SECRET COUNTER TYPE PROVIDER ISSUER ORIGINAL_NAME; do
	URL="otpauth://totp/${EMAIL}?secret=${SECRET}&issuer=${ISSUER}"
    URL=$(echo "${URL}" | sed 's/ /%20/')
    IMG="${QRS}/${_ID}.png"
    printf "* Gen: %50s -->> %s\n" ${EMAIL} ${IMG}
    qrencode -s 20 -o "${IMG}" "${URL}"
done < "${DATA}/dump.csv"
IFS=$OLDIFS

feh -r "${QRS}"

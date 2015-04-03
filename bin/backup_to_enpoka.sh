#!/bin/bash

set -e

LOG_FILE='/var/log/backup.log'
# redirect stdout and stderr to the LOG_FILE
exec &> >(tee -a ${LOG_FILE}) 2>&1 

# This script schecks if access to enpoka is possible.
# If so rsyncs important data to /home/jacob/backup

TARGETS=('/home/jso')
BACKUP_HOSTS=('jacob@enpoka' 'sochan@melchior')
BACKUP_DIR='/home/jacob/backup'
RSYNC_OPTS='--exclude=".*" --exclude=".*/"'

if tty -s; then
    RSYNC_OPTS+=" --info=progress2"
fi

for BACKUP_HOST in $BACKUP_HOSTS; do
    DEST="${BACKUP_HOST}:${BACKUP_DIR}"
    if ! ssh -q $BACKUP_HOST exit; then
        echo "Host not available: ${BACKUP_HOST} Stopping backup procedure."
        continue
    fi

    for TARGET in $TARGETS; do
        echo -n "RSYNC: $TARGET -> $DEST"
        RSYNC_CMD="rsync -arut --delete ${RSYNC_OPTS} \"$TARGET\" \"$DEST\""
        RSYNC_TIME=$(time (RSYNC_OUTPUT=$(eval ${RSYNC_CMD} 2>&1)) 2>&1)
        RSYNC_TIME=$(echo "$RSYNC_TIME" | awk '/real/{print $2}')
        if [[ $? != 0 ]]; then
            echo
            echo "Rsync cmd failed: ${RSYNC_CMD}"
            echo "OUTPUT:"
            echo ${RSYNC_OUTPUT}
        fi
        echo " - Finished in: ${RSYNC_TIME}"
    done
done

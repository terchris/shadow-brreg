#!/bin/sh
# shadow-cron.sh
# this script is started by the cron job

LOCKFILE=/usr/src/app/.shadow-cron.lock
INITIATEDDBFILE=/usr/src/app/database_initiated.txt
GITHUBDIR=/usr/src/app/shadow-brreg

echo "shadow-cron.sh started"

(
    # Attempt to acquire an exclusive lock, fail immediately if it cannot be acquired
    flock -x -n 200 || { echo "Another instance is running"; exit 1; }

    if [ ! -f "$INITIATEDDBFILE" ]; then
        echo "Database not initiated ... we must wait"
    else
        echo "Database ready, starting shadow app"
        node "$GITHUBDIR/app/shadow/dist/index.js"
    fi

) 200>"$LOCKFILE"

echo "shadow-cron.sh finished"

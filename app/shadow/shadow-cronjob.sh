#!/bin/sh
# shadow-cron.sh
# this script is started by the cron job


INITIATEDDBFILE=/usr/src/app/database_initiated.txt
GITHUBDIR=/usr/src/app/shadow-brreg

echo "shadow-cron.sh started"

    if [ ! -f "$INITIATEDDBFILE" ]; then
        echo "Database not initiated ... we must wait"    
    else
        echo "Database ready, starting shadow app"
        node "$GITHUBDIR/app/shadow/dist/index.js"
    fi

echo "shadow-cron.sh finished"
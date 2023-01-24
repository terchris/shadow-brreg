#!/bin/sh
# shadow-cron.sh
# this script is started by the cron job

INSTALLEDFILE=/usr/src/shared/database_download_finished.txt
INITIATEDDBFILE=/usr/src/shared/database_initiated.txt

echo "shadow-cron.sh started"


if [ -f "$INSTALLEDFILE" ]; then 
    echo "Database downloaded and read into database"
    if [ ! -f "$INITIATEDDBFILE" ]; then
        echo "Initiating database"
        node /shadow-brreg/app/shadow/dist/initdb.js
        echo "Creating file for Database initiated"
        date > "$INITIATEDDBFILE" 
        echo "Database initiated First import of changed data from brreg.no"
        node /shadow-brreg/app/shadow/dist/index.js
    else
        echo "Database initiated running import of new data from brreg.no"
        node /shadow-brreg/app/shadow/dist/index.js
    fi
else
    echo "Database not downloaded ... we must wait"    
fi




echo "shadow-cron.sh finished"
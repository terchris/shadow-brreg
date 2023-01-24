#!/bin/sh
# shadow-cron.sh
# this script is started by the cron job

echo "shadow-cron.sh started"
node /shadow-brreg/app/shadow/dist/index.js
echo "shadow-cron.sh finished"
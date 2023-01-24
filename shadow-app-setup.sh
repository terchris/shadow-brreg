#!/bin/sh

# clones the shadow app from github
# and installs it

echo "shadow-app-setup.sh starting"

echo "1. Install git and cron"
apk add git apk-cron

echo "2. Install typescript"
npm install -g typescript


if [ -d "/shadow-brreg" ]; then 
    echo "Remove old shadow-brreg folder"
    rm -rf /shadow-brreg
fi

echo "3. Clone the shadow app from github"
git clone --no-hardlinks https://github.com/terchris/shadow-brreg  


echo "4. Make cron scripts executable"
chmod +x /shadow-brreg/app/shadow/shadow-cronjob.sh


echo "5. Set up and compile the shadow app"
cd /shadow-brreg/app/shadow
echo "6. yarn install"
yarn install
echo "7. yarn build"
yarn build


#yarn initdb

echo "8. Add the job to cron"
/usr/bin/crontab /shadow-brreg/app/shadow/cronjobs.txt
#write to log using  */1 * * * * /shadow-brreg/app/shadow/shadow-cronjob.sh >> /var/log/shadow-cronjob.log

echo "9. Start cron and wait for jobs to run"
echo "======================================"
/usr/sbin/crond -f -l 8
# to list cron jobs: crontab -l

echo "shadow-setup.sh done"

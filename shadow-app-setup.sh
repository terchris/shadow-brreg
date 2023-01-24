#!/bin/sh

# clones the shadow app from github
# and installs it

echo "shadow-app-setup.sh starting"

echo "Install git and cron"
apk add git apk-cron

echo "Install typescript"
npm install -g typescript


if [ -d "/shadow-brreg" ]; then 
    echo "Remove old shadow-brreg folder"
    rm -rf /shadow-brreg
fi

echo "Clone the shadow app from github"
git clone --no-hardlinks https://github.com/terchris/shadow-brreg  


echo "Make scripts executable"
chmod +x /shadow-brreg/app/shadow/shadow-appinstall.sh
chmod +x /shadow-brreg/app/shadow/shadow-cronjob.sh
chmod +x /shadow-brreg/app/shadow/shadow-cronstart.sh


echo "Set up and compile the shadow app"
cd /shadow-brreg/app/shadow
echo "yarn install"
yarn install
echo "yarn build"
yarn build

#ls ./dist -la

#yarn initdb

echo "Add the job to cron"
/usr/bin/crontab /shadow-brreg/app/shadow/cronjobs.txt

echo "Start cron and wait for jobs to run"
/usr/sbin/crond -f -l 8


echo "shadow-setup.sh done"

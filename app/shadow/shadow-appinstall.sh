#!/bin/sh
# shadow-appinstall.sh
# code for installing the shadow app

echo "shadow-appinstall.sh"
if [ -d "/shadow-brreg" ]; then 
  rm -rf /shadow-brreg
fi
git clone --no-hardlinks https://github.com/terchris/shadow-brreg  

# make scripts executable
chmod +x /shadow-brreg/app/shadow/shadow-appinstall.sh
chmod +x /shadow-brreg/app/shadow/shadow-cronjob.sh
chmod +x /shadow-brreg/app/shadow/shadow-cronstart.sh


echo "Set up and compile the shadow app"
cd /shadow-brreg/app/shadow
yarn install
yarn build

ls ./dist -la

#yarn initdb

echo "Set up the cron job"
/usr/bin/crontab /shadow-brreg/app/shadow/cronjobs.txt

echo "Start the cron job"
/usr/sbin/crond -f -l 8


echo "shadow-setup.sh done"

#!/bin/sh
# shadow-appinstall.sh
# code for installing the shadow app

echo "shadow-appinstall.sh"


echo "Set up and compile the shadow app"
cd /shadow-brreg/app/shadow
yarn install
yarn build

ls ./dist -la

#yarn initdb

#echo "Set up the cron job"
#crontab -l > mycron
#echo "*/1 * * * * /shadow-brreg/app/shadow/shadow-cron.sh" >> mycron
#crontab mycron
#rm mycron



echo "shadow-setup.sh done"

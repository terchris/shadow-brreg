# shadow-setup.sh
# code for setting up a shadow copy of the brreg.no database
echo "shadow-setup.sh"

echo "Make shadow-cron.sh executable"
chmod +x /shadow-brreg/app/shadow/shadow-cron.sh

echo "Set up and compile the shadow app"
yarn install
yarn build
#ls ./dist -la
yarn initdb

echo "Set up the cron job"
crontab -l > mycron
echo "*/1 * * * * /shadow-brreg/app/shadow/shadow-cron.sh" >> mycron
crontab mycron
rm mycron



echo "shadow-setup.sh done"

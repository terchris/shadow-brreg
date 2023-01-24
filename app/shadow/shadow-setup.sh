# shadow-setup.sh
# code for setting up a shadow copy of the brreg.no database
echo "shadow-setup.sh"
pwd
ls -la

yarn install
yarn build
echo "shadow-setup.sh done"
ls -la
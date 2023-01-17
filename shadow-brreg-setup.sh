#
# shadow-brreg-setup.sh is a script that download all data from Brønnøysundregistrene (brreg.no)
# and import it into a postgres database
# running this script will take some time as it downloads all data, converts it to csv and imports it into  the database
# Maintanter terchris Terje Christensen

# To use it you mus have docker installed and running
# do this by typing: docker compose up -d
# To download and run this script type:

#docker exec -it shadow-brreg-db-1 wget https://raw.githubusercontent.com/terchris/shadow-brreg/main/shadow-brreg-setup.sh && chmod +x shadow-brreg-setup.sh && ./shadow-brreg-setup.sh

# install libreoffice - it is used for converting xls to csv
apk update && apk add libreoffice

# download database table definition from github
wget https://raw.githubusercontent.com/terchris/shadow-brreg/main/brreg_enheter_alle-table_definition.sql -O /tmp/brreg_enheter_alle-table_definition.sql

# 2 create database in the container
PGPASSWORD="postgres" psql -p 5433 --user=postgres -c "CREATE DATABASE importdata OWNER postgres;"

# 3 delete previous database and downloaded files
## delete previous downloaded table
PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "DROP TABLE brreg_enheter_alle;"
## delete downloaded excel file
rm /tmp/enheter_alle.xlsx
## delete converted cvs file 
rm /tmp/enheter_alle.csv


# 4 create the database table using the definition file
PGPASSWORD="postgres" psql -p 5433 -U postgres -d importdata -f /tmp/brreg_enheter_alle-table_definition.sql

# 5 download excel file enheter_alle.xlsx from brreg.no 
wget --header='Accept: application/vnd.brreg.enhetsregisteret.enhet+vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8' -O /tmp/enheter_alle.xlsx 'https://data.brreg.no/enhetsregisteret/api/enheter/lastned/regneark'

# 6 Convert excel file enheter_alle.xlsx to csv format and name it enheter_alle.csv
soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 /tmp/enheter_alle.xlsx

# 7 import csv file enheter_alle.csv into database
PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "\COPY brreg_enheter_alle FROM '/tmp/enheter_alle.csv' delimiter ',' csv header;"

# 8 delete downloaded files
rm /tmp/enheter_alle.xlsx
rm /tmp/enheter_alle.csv
rm /tmp/brreg_enheter_alle-table_definition.sql
rm /tmp/shadow-brreg-setup.sh 

# 9 create a file so that that file has the date and time of the last update
date > last_update.txt

# 10 add the number of records imported to the file last_update.txt
PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "select count(*) from brreg_enheter_alle;" >> last_update.txt

# 11 display the content of the file last_update.txt
cat last_update.txt
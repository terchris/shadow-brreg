# create container running postgres and load all brreg data into it

# 1 create the container
a) docker compose
b) install libreoffice
apk update && apk add libreoffice


# 2 create database in the container
PGPASSWORD="postgres" psql -p 5433 --user=postgres -c "CREATE DATABASE importdata OWNER postgres;"


# 3 delete previous database and downloaded files
a) delete previous downloaded table
PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "DROP TABLE brreg_enheter_alle;"
b) delete downloaded excel file
rm enheter_alle.xlsx
c) delete converted cvs file 
rm enheter_alle.csv



# 4 create the table that will hold the brreg data in the container

b) download the table definition from github
c) run the command to create the database
PGPASSWORD="postgres" psql -p 5433 -U postgres -d importdata -f brreg_enheter_alle-table_definition.sql


# 4 Download all data in excel format from brreg

wget --header='Accept: application/vnd.brreg.enhetsregisteret.enhet+vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8' -O enheter_alle.xlsx 'https://data.brreg.no/enhetsregisteret/api/enheter/lastned/regneark'


# 5 Convert excel to csv format

soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 enheter_alle.xlsx

# 6 import the csv file into the table 

PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "\COPY brreg_enheter_alle FROM './enheter_alle.csv' delimiter ',' csv header;"



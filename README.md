# shadow-brreg
docker container that keeps a postgres database updated with the latest updates from www.brreg.no The Norwegian public company registration

## Purpose
It will spin up a container that holds two images. One is a standard postgres v14 image that holds the database. 

The volume xxx holds the data files of the postgres database.

The database is available on port 5433 on the host. This so that the port does not interfere with other postgresql instances you may have.  

The next container holds the code that downloads the initial data from brreg.no and then the chron jobs that download all changes to the data every night.


## Backup of dag in the cloud dag.urbalurba.no
user: strapi
database: importdata

PGPASSWORD="..gutta..." pg_dump -U strapi importdata > /home/urbalurba-core/backups/databases/dag-importdata-`date +%d-%m-%y`.sql

* gzip the file
* downlad it locally
* gunzip it

## import dag backup into local postgres database
inside the container
PGPASSWORD="postgres" psql -U postgres -d importdata -f dag-importdata-16-01-23.sql




## excec


docker exec -it shadow-brreg-db-1 -w /hostdir/brregdata pwd


## alternate

docker pull leplusorg/csv  
docker run --rm --net=none leplusorg/csv in2csv -h

not working
docker run --rm --net=none -v "$(pwd):/tmp" leplusorg/csv in2csv /tmp/enheter_alle.xlsx > /tmp/enheter_alle-in2csv.csv


docker exec -d leplusorg/csv
docker exec -it -v "$(pwd):/tmp" leplusorg/csv sh

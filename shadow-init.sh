#!/bin/sh
# shadow-init.sh
# this script is started by the docker-compose.yml file.
# it will set up everything needed to create a shadow database of brreg.no 
# and keep it updated by monitoring brreg.no for changes 
# Maintanter terchris Terje Christensen

# the solution consists of two containers. One is a standard postgres container, the other is a node container that does all the work.

# files used to set status of the installation
INITIATEDDBFILE=/usr/src/app/database_initiated.txt
GITHUBDIR=/usr/src/app/shadow-brreg
DOWNLOADDIR=/usr/src/app/download
BRREGENHETERXLSFILE=enheter_alle.xlsx
BRREGENHETERCSVFILE=enheter_alle.csv
BRREGTABLEDEFINITIONFILE=brreg_enheter_alle-table_definition.sql
CRONJOBSFILE=app/shadow/cronjobs.txt

echo "shadow-init.sh starting"

echo "1. Install git and cron"
apk add git apk-cron postgresql-client py3-pip
# libreoffice is huge, but needed to convert xlsx to csv
# apk add py3-pip
# pip install xlsx2csv

echo "1.a. Install xlsx2csv"
pip install xlsx2csv


echo "2. Install typescript"
npm install -g typescript


echo "3. Clone the shadow app from github to $GITHUBDIR"
git clone --no-hardlinks https://github.com/terchris/shadow-brreg "$GITHUBDIR"

read -p "Press any key..."

echo "4. Make cron scripts executable"
chmod +x "$GITHUBDIR/app/shadow/shadow-cronjob.sh"


echo "5. Set up and compile the shadow app"
cd "$GITHUBDIR/app/shadow"

read -p "Press any key..."

echo "6. yarn install"
yarn install
echo "7. yarn build"
yarn build

read -p "Press any key..."

echo "8. Check if database is initiated "
if [ ! -f "$INITIATEDDBFILE" ]; then 
    echo "8a. Database is not initiated"
    echo "8b. create download folder $DOWNLOADDIR"
    mkdir "$DOWNLOADDIR"

    read -p "Press any key..."

    echo "8c. download excel file enheter_alle.xlsx from brreg.no to $DOWNLOADDIR/$BRREGENHETERXLSFILE"
    wget --header='Accept: application/vnd.brreg.enhetsregisteret.enhet+vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8' -O "$DOWNLOADDIR/$BRREGENHETERXLSFILE" 'https://data.brreg.no/enhetsregisteret/api/enheter/lastned/regneark'

    read -p "Press any key..."

    echo "8d. convert excel file $BRREGENHETERXLSFILE to csv format and name it $BRREGENHETERCSVFILE"
    #soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 "$DOWNLOADDIR/$BRREGENHETERXLSFILE" --outdir "$DOWNLOADDIR" 
    xlsx2csv "$DOWNLOADDIR/$BRREGENHETERXLSFILE" "$DOWNLOADDIR/$BRREGENHETERCSVFILE"

    read -p "Press any key..."

    echo "8e. wait until the databse in the other container is ready" 
    until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER"
    do
        echo "... waiting for database to be ready ..."
        sleep 1
    done
    sleep 2
    echo "8f. Database is ready"

    read -p "Press any key..."

    echo "8g. create the database: $DATABASE_NAME"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" --user="$DATABASE_USER" -c "CREATE DATABASE $DATABASE_NAME OWNER $DATABASE_USER;"

    read -p "Press any key..."

    echo "8h. Drop the table brreg_enheter_alle if it exists"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" --user="$DATABASE_USER" -c "DROP TABLE brreg_enheter_alle;"

    read -p "Press any key..."

    echo "8i. create the table brreg_enheter_alle usinf definition in $BRREGTABLEDEFINITIONFILE"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -f "$GITHUBDIR "/"$BRREGTABLEDEFINITIONFILE"

    read -p "Press any key..."

    echo "8j. Import the csv file $BRREGENHETERCSVFILE to the database"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "\copy brreg_enheter_alle FROM '$DOWNLOADDIR/$BRREGENHETERCSVFILE' DELIMITER ',' CSV HEADER;"
    
    read -p "Press any key..."

    echo "8k. Create a file $INITIATEDDBFILE to indicate that the database is initiated"
    date > "$INITIATEDDBFILE"

    read -p "Press any key..."

    echo "8l. Delete the downloaded files: $BRREGENHETERXLSFILE and $BRREGENHETERCSVFILE"
    #rm "$DOWNLOADDIR/$BRREGENHETERXLSFILE"
    #rm "$DOWNLOADDIR/$BRREGENHETERCSVFILE"

    read -p "Press any key..."

    echo "8m. Add the number of records imported to the $INITIATEDDBFILE file"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "SELECT COUNT(*) FROM brreg_enheter_alle;" >> "$INITIATEDDBFILE"
    
    read -p "Press any key..."

    echo "8n. Display the $INITIATEDDBFILE file"
    cat "$INITIATEDDBFILE"

    read -p "Press any key..."

    echo "8o. Add and initiate tables used by the node app to keep the database updated"
    node "$GITHUBDIR/app/shadow/dist/initdb.js"
fi

echo "8. Add the job to cron"
/usr/bin/crontab "$GITHUBDIR/$CRONJOBSFILE"

echo "9. Start cron and wait for jobs to run"
echo "======================================"
/usr/sbin/crond -f -l 8
# to list cron jobs: crontab -l

echo "shadow-setup.sh done"


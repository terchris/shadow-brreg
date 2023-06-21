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

echo "shadow-init.sh starting. This is the variables used:"
echo "INITIATEDDBFILE=$INITIATEDDBFILE"
echo "GITHUBDIR=$GITHUBDIR"
echo "DOWNLOADDIR=$DOWNLOADDIR"
echo "BRREGENHETERXLSFILE=$BRREGENHETERXLSFILE"
echo "BRREGENHETERCSVFILE=$BRREGENHETERCSVFILE"
echo "BRREGTABLEDEFINITIONFILE=$BRREGTABLEDEFINITIONFILE"
echo "CRONJOBSFILE=$CRONJOBSFILE"
echo "DATABASE_HOST=$DATABASE_HOST"
echo "DATABASE_PORT=$DATABASE_PORT"
echo "DATABASE_USER=$DATABASE_USER"
echo "DATABASE_PASSWORD=$DATABASE_PASSWORD"
echo "DATABASE_NAME=$DATABASE_NAME"



echo "1. Install git and cron"
apk add git apk-cron postgresql-client py3-pip
# libreoffice is huge, but needed to convert xlsx to csv
# apk add py3-pip
# pip install xlsx2csv

echo "1.a. Install xlsx2csv"
pip install xlsx2csv


echo "2. Install typescript"
npm install -g typescript


echo "2.5. delete the shadow app if it exists"
rm -rf "$GITHUBDIR"

echo "3. Clone the shadow app from github to $GITHUBDIR"
git clone --no-hardlinks https://github.com/terchris/shadow-brreg "$GITHUBDIR"



echo "4. Make cron scripts executable"
chmod +x "$GITHUBDIR/app/shadow/shadow-cronjob.sh"


echo "5. Set up and compile the shadow app"
cd "$GITHUBDIR/app/shadow"



echo "6. yarn install"
yarn install
echo "7. yarn build"
yarn build



echo "8. Check if database is initiated "
if [ ! -f "$INITIATEDDBFILE" ]; then 
    echo "8a. Database is not initiated"
    echo "8b. create download folder $DOWNLOADDIR"
    mkdir "$DOWNLOADDIR"

    

    echo "8c. download excel file enheter_alle.xlsx from brreg.no to $DOWNLOADDIR/$BRREGENHETERXLSFILE"
    wget --header='Accept: application/vnd.brreg.enhetsregisteret.enhet+vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8' -O "$DOWNLOADDIR/$BRREGENHETERXLSFILE" 'https://data.brreg.no/enhetsregisteret/api/enheter/lastned/regneark'

    

    echo "8d. TAKES TIME to convert excel file $BRREGENHETERXLSFILE to csv format and name it $BRREGENHETERCSVFILE"
    echo "!! brreg.no is a Microsoft shop and prefer to use the proprietary Microsoft Office format. !!"
    echo "!! We need to convert it to a more open format. This takes time. !!"
    echo "!! If brreg.no created the file in the open cvs format and compressed it we would save:  !!"
    echo "!! time, bandwith, and disk space. !!"
    echo "!! tell them what you think about this by sendng them an email to media@brreg.no !!"
    start=`date +%s`
    xlsx2csv "$DOWNLOADDIR/$BRREGENHETERXLSFILE" "$DOWNLOADDIR/$BRREGENHETERCSVFILE"
    end=`date +%s`
    echo You wasted  `expr $end - $start` seconds of your life converting the file
    

    echo "8e. wait until the databse in the other container is ready" 
    until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER"
    do
        echo "... waiting for database to be ready ..."
        sleep 1
    done
    sleep 2
    echo "8f. Database is ready"

    

    echo "8g. create the database: $DATABASE_NAME"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" --user="$DATABASE_USER" -c "CREATE DATABASE $DATABASE_NAME OWNER $DATABASE_USER;"
    

    echo "8h. create the table brreg_enheter_alle using definition in $BRREGTABLEDEFINITIONFILE"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -f "$GITHUBDIR"/"$BRREGTABLEDEFINITIONFILE"

    

    echo "8i. Import the csv file $BRREGENHETERCSVFILE to the database"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "\copy brreg_enheter_alle FROM '$DOWNLOADDIR/$BRREGENHETERCSVFILE' DELIMITER ',' CSV HEADER;"
    
    

    echo "8j. Create a file $INITIATEDDBFILE to indicate that the database is initiated"
    date > "$INITIATEDDBFILE"

    

    echo "8k. Delete the downloaded files: $BRREGENHETERXLSFILE and $BRREGENHETERCSVFILE"
    #rm "$DOWNLOADDIR/$BRREGENHETERXLSFILE"
    #rm "$DOWNLOADDIR/$BRREGENHETERCSVFILE"

    

    echo "8l. Add the number of records imported to the $INITIATEDDBFILE file"
    PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "SELECT COUNT(*) FROM brreg_enheter_alle;" >> "$INITIATEDDBFILE"
    
    

    echo "8m. Display the $INITIATEDDBFILE file"
    cat "$INITIATEDDBFILE"

    

    echo "8n. Add and initiate tables used by the node app to keep the database updated"
    node "$GITHUBDIR/app/shadow/dist/initdb.js"
fi

echo "9. Add the job to cron"
/usr/bin/crontab "$GITHUBDIR/$CRONJOBSFILE"
# you must set the absolute path to the script in the cronjob file

echo "10. Start cron and wait for jobs to run"
echo "======================================"
/usr/sbin/crond -f -l 8
# to list cron jobs: crontab -l

echo "shadow-setup.sh done"


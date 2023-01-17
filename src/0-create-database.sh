# 1-create-database
# creates the database importdata
# notice that postgres is running on port 5433
# Usage: 1-create-database.sh 

psql -p 5433 --user=postgres -c "CREATE DATABASE importdata OWNER postgres;"
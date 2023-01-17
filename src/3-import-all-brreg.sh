# 3-import-all-brreg
# import the file enheter_alle.csv into the database
# notice that postgres is running on port 5433
# Usage: 3-import-all-brreg.sh 

# the conteiner running postgres is called ""

PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "\COPY brreg_enheter_alle FROM './enheter_alle.csv' delimiter ',' csv header;"
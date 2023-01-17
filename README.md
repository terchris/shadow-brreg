# shadow-brreg
docker container that keeps a postgres database updated with the latest updates from www.brreg.no The Norwegian public company registration, Brønnøysundregistrene.

The Brønnøysundregistrene has all information about companies and organizations in Norway.

## Purpose
It will spin up a container that holds a postgres database with all data from brreg.no


The database is available on port 5433 on the host. This so that the port does not interfere with other postgresql instances you may have.  

## how to use
* start the container
docker compose up -d

* run the script that does it all
docker exec -it shadow-brreg-db-1 wget https://raw.githubusercontent.com/terchris/shadow-brreg/main/shadow-brreg-setup.sh && chmod +x shadow-brreg-setup.sh && ./shadow-brreg-setup.sh

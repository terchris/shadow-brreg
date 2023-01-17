# shadow-brreg
docker container that keeps a postgres database updated with the latest updates from www.brreg.no The Norwegian public company registration, Brønnøysundregistrene.

The Brønnøysundregistrene has all information about companies and organizations in Norway.

## Purpose
It will spin up a container that holds a postgres database with all data from brreg.no


The database is available on port 5433 on the host. This so that the port does not interfere with other postgresql instances you may have.  

## how to set it up
* copy the docker-compose.yml file to your local dir
```
wget https://raw.githubusercontent.com/terchris/shadow-brreg/main/docker-compose.yml -O docker-compose.yml
```
or 
```
curl https://raw.githubusercontent.com/terchris/shadow-brreg/main/docker-compose.yml -o docker-compose.yml
```

* start the container
```
docker compose up -d
```
* Check that the container is running
```
docker ps 
```
You should see something like:
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED        STATUS        PORTS                              NAMES
48468bc8c9d9   dpage/pgadmin4         "/entrypoint.sh"         19 hours ago   Up 19 hours   443/tcp, 0.0.0.0:5050->80/tcp      pgadmin-pgadmin-1
a0840f5b7b9a   postgres:14.1-alpine   "docker-entrypoint.s…"   22 hours ago   Up 19 hours   5432/tcp, 0.0.0.0:5433->5433/tcp   shadow-brreg-db-1
6bb78d05c52c   postgres:14.1-alpine   "docker-entrypoint.s…"   3 days ago     Up 3 days     0.0.0.0:5432->5432/tcp             postgres-db-1
```
The container is named `shadow-brreg-db-1`

* run the script that does it all
```
docker exec -it shadow-brreg-db-1 /bin/bash -c "set -e; wget https://raw.githubusercontent.com/terchris/shadow-brreg/main/shadow-brreg-setup.sh -O /tmp/shadow-brreg-setup.sh && chmod +x /tmp/shadow-brreg-setup.sh && /tmp/shadow-brreg-setup.sh"
```

* check how many records are imported to the table 
```
docker exec -it shadow-brreg-db-1 cat last_update.txt
```
The result should be something like this:
```
Tue Jan 17 10:58:44 UTC 2023
  count  
---------
 1048575
(1 row)
```

## to update with new data

The system is not smart. It just downloads all data every time. 
So to get new data you just run the script that does it all one more time.

## passwords and security

The database user is `postgres` and the password is `postgres` and everyone that has access to your host at port 5433 can add and delete stuff in your database.
I suggest that you edit the script and change the password. Or safest you just stop the container when you are not using it.
To stop it. Type this in the directory where you downloaded the docker-ompose.yml file:
```
docker compose down
```


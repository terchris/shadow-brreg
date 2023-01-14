# shadow-brreg
docker container that keeps a postgres database updated with the latest updates from www.brreg.no The Norwegian public company registration

## Purpose
It will spin up a container that holds two images. One is a standard postgres v14 image that holds the database. 

The volume xxx holds the data files of the postgres database.

The database is available on port 5433 on the host. This so that the port does not interfere with other postgresql instances you may have.  

The next container holds the code that downloads the initial data from brreg.no and then the chron jobs that download all changes to the data every night.



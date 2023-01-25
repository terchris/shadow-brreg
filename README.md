# shadow-brreg
docker container that keeps a postgres database updated with the latest updates from www.brreg.no The Norwegian public company registration, Brønnøysundregistrene.

The Brønnøysundregistrene has all information about companies and organizations in Norway.

# Code written by ChatGPT and Github Copilot
The code for automatic update of the database is written by by ChatGPT,  @terchris and Github Copilot. In plain english I asked ChatGPT to write the code and he/she/it did. ChatGPT is unstable so I wrote all my questions in a file before pasting the question to ChatGPT. As I was writing my questions, Github Copilot suggested how to write the questions in plain english.  So there I got one AI helping me to talk to another AI.

What impressed me the most was that ChatGPT was able to understand that the database table (brreg_enheter_alle) contains organizations. So I could ask it to do stuff like this:
```
The table brreg_enheter_alle is a table of organizations. The number of employees are defined by the field antall_ansatte. Create a new function named getLargestOrganizations that returns the records that has the most employees. Sort the results so that the organization with the largest amount of employees is at the top. There are many records in the table so it must be possible to pass a parameter named numberOfOrganizations to the function getLargestOrganizations that defines how many organizations to return. Use the already defined function displayRecords to display the result.
```
And ChatGPT wrote the code for me. I just had to copy and paste it into the file and run it. Before I asked ChatGPT to write code for me I asked 20 questions about how to set up the development environment for accessing the database, typescript compiler options, getting debugging to work properly in vscode and so on.

I learned a lot from the experiment. New ways of writing code that I was not aware of.
It was like having a teacher sitting next to me. 

Coding style vary a lot in the code that ChatGPT give you. I can undestand this as ChatGPT is trained on code from many developers.
So when I had to write the code for the automatic update of the database (in this repository) I had to change the coding style so that it would be easier to read. 
(parameter names names and how to return values from functions)

There was one more AI assisting me, Copilot nad ChatGPT. I'm dyslectic and I oftem misspell words. I use a chrome plugin named Grammarly that checks and rates the readability of the questions I ask ChatGPT. 

You will find the code written by CahtGPT, Github Copilot and me iin the repository: https://github.com/terchris/shadow-brreg-node
The questions and answers are in the file: chatGPT.MD


## Purpose of shadow-brreg is to make it easy to get access to the data from brreg.no
It will spin up a container that holds a postgres database with all data from brreg.no

The database holds more than a million records. And you can use it to play with machine learning, data science, data analysis, data visualization and so on.

The database is available on port 5433 on the host. This so that the port does not interfere with other postgresql instances you may have.  

pgAdmin is available on port 5050 on the host. To access pgAdmin you need to login with the user `postgres@mamma.no` and the password `postgres`. The URL is `http://localhost:5050`


## how to set it up
To start he whole thing you need just one file. The docker-compose.yml file. This file will download the latest version of the database and start the automatic updating of the database.
* copy the docker-compose.yml file to your local dir
```
wget https://raw.githubusercontent.com/terchris/shadow-brreg/main/docker-compose.yml -O docker-compose.yml
```
or 
```
curl https://raw.githubusercontent.com/terchris/shadow-brreg/main/docker-compose.yml -o docker-compose.yml
```

* start the container
In the directory where you downloaded the docker-compose.yml file type:
```
docker compose up -d
```

* check how many records are imported to the table 
```
docker exec -it shadow-app cat /usr/src/app/database_initiated.txt
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

Changes brreg.no does to their data is fetched and updated in the local databseevery minute. All changes they do to the data is available in the database.


## passwords and security

The database user is `postgres` and the password is `postgres` and everyone that has access to your host at port 5433 can add and delete stuff in your database.
I suggest that you edit the script and change the password. Or safest you just stop the container when you are not using it.
To stop it. Type this in the directory where you downloaded the docker-ompose.yml file:
```
docker compose down
```

## how to access the database

databasename: importdata
user: postgres
password: postgres
table: brreg_enheter_alle
port: 5433

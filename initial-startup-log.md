# Initial startup log

The first time the container is started it will download the data from brreg.no and import it to the database. This takes a while. The log from the first startup is shown below.

## Creating the container, installing programs and starting the setup script

```
2023-01-26 08:18:46 Connecting to raw.githubusercontent.com (185.199.111.133:443)
2023-01-26 08:18:46 saving to 'shadow-init.sh'
2023-01-26 08:18:46 shadow-init.sh       100% |********************************|  5484  0:00:00 ETA
2023-01-26 08:18:46 'shadow-init.sh' saved
2023-01-26 08:18:46 shadow-init.sh starting. This is the variables used:
2023-01-26 08:18:46 INITIATEDDBFILE=/usr/src/app/database_initiated.txt
2023-01-26 08:18:46 GITHUBDIR=/usr/src/app/shadow-brreg
2023-01-26 08:18:46 DOWNLOADDIR=/usr/src/app/download
2023-01-26 08:18:46 BRREGENHETERXLSFILE=enheter_alle.xlsx
2023-01-26 08:18:46 BRREGENHETERCSVFILE=enheter_alle.csv
2023-01-26 08:18:46 BRREGTABLEDEFINITIONFILE=brreg_enheter_alle-table_definition.sql
2023-01-26 08:18:46 CRONJOBSFILE=app/shadow/cronjobs.txt
2023-01-26 08:18:46 DATABASE_HOST=db
2023-01-26 08:18:46 DATABASE_PORT=5433
2023-01-26 08:18:46 DATABASE_USER=postgres
2023-01-26 08:18:46 DATABASE_PASSWORD=postgres
2023-01-26 08:18:46 DATABASE_NAME=importdata
2023-01-26 08:18:46 1. Install git and cron
2023-01-26 08:18:46 fetch https://dl-cdn.alpinelinux.org/alpine/v3.17/main/aarch64/APKINDEX.tar.gz
2023-01-26 08:18:47 fetch https://dl-cdn.alpinelinux.org/alpine/v3.17/community/aarch64/APKINDEX.tar.gz
2023-01-26 08:18:47 (1/29) Installing apk-cron (1.0-r3)
2023-01-26 08:18:47 (2/29) Installing ca-certificates (20220614-r4)
2023-01-26 08:18:47 (3/29) Installing brotli-libs (1.0.9-r9)
2023-01-26 08:18:48 (4/29) Installing nghttp2-libs (1.51.0-r0)
2023-01-26 08:18:48 (5/29) Installing libcurl (7.87.0-r1)
2023-01-26 08:18:48 (6/29) Installing libexpat (2.5.0-r0)
2023-01-26 08:18:48 (7/29) Installing pcre2 (10.42-r0)
2023-01-26 08:18:48 (8/29) Installing git (2.38.3-r1)
2023-01-26 08:18:48 (9/29) Installing postgresql-common (1.1-r2)
2023-01-26 08:18:48 Executing postgresql-common-1.1-r2.pre-install
2023-01-26 08:18:48 (10/29) Installing lz4-libs (1.9.4-r1)
2023-01-26 08:18:48 (11/29) Installing libpq (15.1-r0)
2023-01-26 08:18:48 (12/29) Installing ncurses-terminfo-base (6.3_p20221119-r0)
2023-01-26 08:18:48 (13/29) Installing ncurses-libs (6.3_p20221119-r0)
2023-01-26 08:18:48 (14/29) Installing readline (8.2.0-r0)
2023-01-26 08:18:48 (15/29) Installing zstd-libs (1.5.2-r9)
2023-01-26 08:18:48 (16/29) Installing postgresql15-client (15.1-r0)
2023-01-26 08:18:48 (17/29) Installing libbz2 (1.0.8-r4)
2023-01-26 08:18:48 (18/29) Installing libffi (3.4.4-r0)
2023-01-26 08:18:48 (19/29) Installing gdbm (1.23-r0)
2023-01-26 08:18:48 (20/29) Installing xz-libs (5.2.9-r0)
2023-01-26 08:18:48 (21/29) Installing mpdecimal (2.5.1-r1)
2023-01-26 08:18:48 (22/29) Installing sqlite-libs (3.40.1-r0)
2023-01-26 08:18:48 (23/29) Installing python3 (3.10.9-r1)
2023-01-26 08:18:50 (24/29) Installing py3-six (1.16.0-r3)
2023-01-26 08:18:50 (25/29) Installing py3-retrying (1.3.3-r3)
2023-01-26 08:18:50 (26/29) Installing py3-parsing (3.0.9-r0)
2023-01-26 08:18:50 (27/29) Installing py3-packaging (21.3-r2)
2023-01-26 08:18:50 (28/29) Installing py3-setuptools (65.6.0-r0)
2023-01-26 08:18:50 (29/29) Installing py3-pip (22.3.1-r1)
2023-01-26 08:18:51 Executing busybox-1.35.0-r29.trigger
2023-01-26 08:18:51 Executing ca-certificates-20220614-r4.trigger
2023-01-26 08:18:51 Executing postgresql-common-1.1-r2.trigger
2023-01-26 08:18:51 OK: 98 MiB in 46 packages
2023-01-26 08:18:51 1.a. Install xlsx2csv
2023-01-26 08:18:52 Collecting xlsx2csv
2023-01-26 08:18:52   Downloading xlsx2csv-0.8.1-py3-none-any.whl (13 kB)
2023-01-26 08:18:52 Installing collected packages: xlsx2csv
2023-01-26 08:18:52 Successfully installed xlsx2csv-0.8.1
2023-01-26 08:18:52 2. Install typescript
2023-01-26 08:19:04 
2023-01-26 08:19:04 added 1 package, and audited 2 packages in 11s
2023-01-26 08:19:04 
2023-01-26 08:18:51 * Setting postgresql15 as the default version
2023-01-26 08:18:52 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
2023-01-26 08:19:04 found 0 vulnerabilities
2023-01-26 08:19:04 3. Clone the shadow app from github to /usr/src/app/shadow-brreg
2023-01-26 08:19:06 4. Make cron scripts executable
2023-01-26 08:19:06 5. Set up and compile the shadow app
2023-01-26 08:19:06 6. yarn install
2023-01-26 08:19:06 yarn install v1.22.19
2023-01-26 08:19:06 info No lockfile found.
2023-01-26 08:19:06 [1/4] Resolving packages...
2023-01-26 08:19:12 [2/4] Fetching packages...
2023-01-26 08:19:14 [3/4] Linking dependencies...
2023-01-26 08:19:14 [4/4] Building fresh packages...
2023-01-26 08:19:14 success Saved lockfile.
2023-01-26 08:19:14 Done in 8.86s.
2023-01-26 08:19:15 7. yarn build
2023-01-26 08:19:15 yarn run v1.22.19
2023-01-26 08:19:15 $ tsc
2023-01-26 08:19:16 Done in 1.23s.
2023-01-26 08:19:16 8. Check if database is initiated 
2023-01-26 08:19:16 8a. Database is not initiated
2023-01-26 08:19:16 8b. create download folder /usr/src/app/download
2023-01-26 08:19:16 8c. download excel file enheter_alle.xlsx from brreg.no to /usr/src/app/download/enheter_alle.xlsx
2023-01-26 08:19:04 npm notice 
2023-01-26 08:19:04 npm notice New major version of npm available! 8.19.3 -> 9.4.0
2023-01-26 08:19:04 npm notice Changelog: <https://github.com/npm/cli/releases/tag/v9.4.0>
2023-01-26 08:19:04 npm notice Run `npm install -g npm@9.4.0` to update!
2023-01-26 08:19:04 npm notice 
2023-01-26 08:19:04 Cloning into '/usr/src/app/shadow-brreg'...
2023-01-26 08:19:16 Connecting to data.brreg.no (195.43.63.111:443)
```

## Downloading all companies (propreietary Microsoft xlsx formated file enheter_alle.xlsx) from brreg.no and convert the file to the open csv format

```
2023-01-26 08:19:16 saving to '/usr/src/app/download/enheter_alle.xlsx'
2023-01-26 08:19:16 enheter_alle.xlsx      0% |                                | 40332  1:24:47 ETA
2023-01-26 08:19:17 enheter_alle.xlsx      0% |                                |  735k  0:09:01 ETA
2023-01-26 08:19:18 enheter_alle.xlsx      0% |                                | 1686k  0:05:52 ETA
2023-01-26 08:19:19 enheter_alle.xlsx      1% |                                | 3538k  0:03:41 ETA
2023-01-26 08:19:20 enheter_alle.xlsx      3% |                                | 6142k  0:02:37 ETA
2023-01-26 08:19:21 enheter_alle.xlsx      4% |*                               | 9479k  0:02:00 ETA
2023-01-26 08:19:22 enheter_alle.xlsx      6% |**                              | 12.4M  0:01:42 ETA
2023-01-26 08:19:23 enheter_alle.xlsx      7% |**                              | 15.4M  0:01:33 ETA
2023-01-26 08:19:24 enheter_alle.xlsx      9% |***                             | 18.6M  0:01:25 ETA
2023-01-26 08:19:25 enheter_alle.xlsx     11% |***                             | 21.8M  0:01:19 ETA
2023-01-26 08:19:26 enheter_alle.xlsx     12% |****                            | 25.0M  0:01:14 ETA
2023-01-26 08:19:27 enheter_alle.xlsx     14% |****                            | 28.2M  0:01:10 ETA
2023-01-26 08:19:28 enheter_alle.xlsx     15% |*****                           | 31.1M  0:01:08 ETA
2023-01-26 08:19:29 enheter_alle.xlsx     17% |*****                           | 33.7M  0:01:06 ETA
2023-01-26 08:19:30 enheter_alle.xlsx     18% |******                          | 36.9M  0:01:04 ETA
2023-01-26 08:19:31 enheter_alle.xlsx     20% |******                          | 40.0M  0:01:01 ETA
2023-01-26 08:19:32 enheter_alle.xlsx     22% |*******                         | 43.2M  0:00:59 ETA
2023-01-26 08:19:33 enheter_alle.xlsx     23% |*******                         | 46.4M  0:00:57 ETA
2023-01-26 08:19:34 enheter_alle.xlsx     25% |********                        | 49.7M  0:00:55 ETA
2023-01-26 08:19:35 enheter_alle.xlsx     27% |********                        | 53.0M  0:00:53 ETA
2023-01-26 08:19:36 enheter_alle.xlsx     28% |*********                       | 55.9M  0:00:52 ETA
2023-01-26 08:19:37 enheter_alle.xlsx     30% |*********                       | 59.0M  0:00:50 ETA
2023-01-26 08:19:38 enheter_alle.xlsx     32% |**********                      | 62.4M  0:00:48 ETA
2023-01-26 08:19:39 enheter_alle.xlsx     33% |**********                      | 65.3M  0:00:47 ETA
2023-01-26 08:19:40 enheter_alle.xlsx     34% |***********                     | 67.8M  0:00:46 ETA
2023-01-26 08:19:41 enheter_alle.xlsx     36% |***********                     | 70.9M  0:00:45 ETA
2023-01-26 08:19:42 enheter_alle.xlsx     38% |************                    | 74.2M  0:00:43 ETA
2023-01-26 08:19:43 enheter_alle.xlsx     39% |************                    | 77.2M  0:00:42 ETA
2023-01-26 08:19:44 enheter_alle.xlsx     41% |*************                   | 80.3M  0:00:41 ETA
2023-01-26 08:19:45 enheter_alle.xlsx     42% |*************                   | 83.5M  0:00:40 ETA
2023-01-26 08:19:46 enheter_alle.xlsx     44% |**************                  | 86.7M  0:00:38 ETA
2023-01-26 08:19:47 enheter_alle.xlsx     45% |**************                  | 89.6M  0:00:37 ETA
2023-01-26 08:19:48 enheter_alle.xlsx     47% |***************                 | 92.5M  0:00:36 ETA
2023-01-26 08:19:49 enheter_alle.xlsx     49% |***************                 | 95.7M  0:00:35 ETA
2023-01-26 08:19:50 enheter_alle.xlsx     50% |****************                | 99.0M  0:00:33 ETA
2023-01-26 08:19:51 enheter_alle.xlsx     52% |****************                |  102M  0:00:32 ETA
2023-01-26 08:19:52 enheter_alle.xlsx     54% |*****************               |  105M  0:00:31 ETA
2023-01-26 08:19:53 enheter_alle.xlsx     55% |*****************               |  108M  0:00:30 ETA
2023-01-26 08:19:54 enheter_alle.xlsx     57% |******************              |  111M  0:00:29 ETA
2023-01-26 08:19:55 enheter_alle.xlsx     58% |******************              |  113M  0:00:28 ETA
2023-01-26 08:19:56 enheter_alle.xlsx     59% |*******************             |  116M  0:00:27 ETA
2023-01-26 08:19:57 enheter_alle.xlsx     61% |*******************             |  119M  0:00:26 ETA
2023-01-26 08:19:58 enheter_alle.xlsx     62% |********************            |  122M  0:00:25 ETA
2023-01-26 08:19:59 enheter_alle.xlsx     64% |********************            |  126M  0:00:24 ETA
2023-01-26 08:20:00 enheter_alle.xlsx     66% |*********************           |  129M  0:00:22 ETA
2023-01-26 08:20:01 enheter_alle.xlsx     67% |*********************           |  132M  0:00:21 ETA
2023-01-26 08:20:02 enheter_alle.xlsx     69% |**********************          |  135M  0:00:20 ETA
2023-01-26 08:20:03 enheter_alle.xlsx     71% |**********************          |  138M  0:00:19 ETA
2023-01-26 08:20:04 enheter_alle.xlsx     72% |***********************         |  141M  0:00:18 ETA
2023-01-26 08:20:05 enheter_alle.xlsx     74% |***********************         |  144M  0:00:17 ETA
2023-01-26 08:20:06 enheter_alle.xlsx     75% |************************        |  148M  0:00:16 ETA
2023-01-26 08:20:07 enheter_alle.xlsx     77% |************************        |  151M  0:00:15 ETA
2023-01-26 08:20:08 enheter_alle.xlsx     78% |*************************       |  153M  0:00:14 ETA
2023-01-26 08:20:09 enheter_alle.xlsx     80% |*************************       |  156M  0:00:13 ETA
2023-01-26 08:20:10 enheter_alle.xlsx     81% |**************************      |  159M  0:00:12 ETA
2023-01-26 08:20:11 enheter_alle.xlsx     83% |**************************      |  162M  0:00:11 ETA
2023-01-26 08:20:12 enheter_alle.xlsx     85% |***************************     |  166M  0:00:09 ETA
2023-01-26 08:20:13 enheter_alle.xlsx     86% |***************************     |  169M  0:00:08 ETA
2023-01-26 08:20:14 enheter_alle.xlsx     88% |****************************    |  171M  0:00:07 ETA
2023-01-26 08:20:15 enheter_alle.xlsx     89% |****************************    |  174M  0:00:06 ETA
2023-01-26 08:20:16 enheter_alle.xlsx     91% |*****************************   |  177M  0:00:05 ETA
2023-01-26 08:20:17 enheter_alle.xlsx     92% |*****************************   |  181M  0:00:04 ETA
2023-01-26 08:20:18 enheter_alle.xlsx     94% |******************************  |  184M  0:00:03 ETA
2023-01-26 08:20:19 enheter_alle.xlsx     96% |******************************  |  187M  0:00:02 ETA
2023-01-26 08:20:20 enheter_alle.xlsx     98% |******************************* |  191M  0:00:01 ETA
2023-01-26 08:20:21 enheter_alle.xlsx     99% |******************************* |  194M  0:00:00 ETA
2023-01-26 08:20:21 enheter_alle.xlsx    100% |********************************|  195M  0:00:00 ETA
2023-01-26 08:20:21 '/usr/src/app/download/enheter_alle.xlsx' saved
2023-01-26 08:20:21 8d. TAKES TIME to convert excel file enheter_alle.xlsx to csv format and name it enheter_alle.csv
2023-01-26 08:20:21 !! brreg.no is a Microsoft shop and prefer to use the proprietary Microsoft Office format. !!
2023-01-26 08:20:21 !! We need to convert it to a more open format. This takes time. !!
2023-01-26 08:20:21 !! If brreg.no created the file in the open cvs format and compressed it we would save:  !!
2023-01-26 08:20:21 !! time, bandwith, and disk space. !!
2023-01-26 08:20:21 !! tell them what you think about this by sendng them an email to media@brreg.no !!
2023-01-26 08:22:12 You wasted 111 seconds of your life converting the file
```

## Create database and import the csv file into the database

```
2023-01-26 08:22:12 8e. wait until the databse in the other container is ready
2023-01-26 08:22:12 db:5433 - accepting connections
2023-01-26 08:22:14 8f. Database is ready
2023-01-26 08:22:14 8g. create the database: importdata
2023-01-26 08:22:14 CREATE DATABASE
2023-01-26 08:22:14 8h. create the table brreg_enheter_alle using definition in brreg_enheter_alle-table_definition.sql
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14  set_config 
2023-01-26 08:22:14 ------------
2023-01-26 08:22:14  
2023-01-26 08:22:14 (1 row)
2023-01-26 08:22:14 
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 SET
2023-01-26 08:22:14 CREATE TABLE
2023-01-26 08:22:14 ALTER TABLE
2023-01-26 08:22:14 ALTER TABLE
2023-01-26 08:22:14 8i. Import the csv file enheter_alle.csv to the database
2023-01-26 08:22:19 COPY 1048575
2023-01-26 08:22:19 8j. Create a file /usr/src/app/database_initiated.txt to indicate that the database is initiated
2023-01-26 08:22:19 8k. Delete the downloaded files: enheter_alle.xlsx and enheter_alle.csv
2023-01-26 08:22:19 8l. Add the number of records imported to the /usr/src/app/database_initiated.txt file
2023-01-26 08:22:20 8m. Display the /usr/src/app/database_initiated.txt file
2023-01-26 08:22:20 Thu Jan 26 07:22:19 UTC 2023
2023-01-26 08:22:20   count  
2023-01-26 08:22:20 ---------
2023-01-26 08:22:20  1048575
2023-01-26 08:22:20 (1 row)
2023-01-26 08:22:20 
```

## Set up tables used by the node app to keep the database updated

```
2023-01-26 08:22:20 8n. Add and initiate tables used by the node app to keep the database updated
2023-01-26 08:22:20 urbalurba_status table is ready and initialized with the date of when the database was created. Witch is: Thu Jan 26 2023 00:00:01 GMT+0000 (Coordinated Universal Time)
2023-01-26 08:22:20 oppdaterteEnheter table is ready to receive data
2023-01-26 08:22:20 Fields added successfully to brreg_enheter_alle table
2023-01-26 08:22:20 OK! Tables and fields have been successfully initiated.
```

## Add node app to cron and start cron 

```
2023-01-26 08:22:30 9. Add the job to cron
2023-01-26 08:22:30 10. Start cron and wait for jobs to run
2023-01-26 08:22:30 ======================================
```

## The first job will run in 1 minute

```
2023-01-26 08:23:00 shadow-cron.sh started
2023-01-26 08:23:00 Database ready, starting shadow app
2023-01-26 08:23:00 All database variables are set
2023-01-26 08:23:00 Testing db connection ... dateNow:  2023-01-26T07:23:00.364Z
2023-01-26 08:23:00 Database connection is ok
2023-01-26 08:23:00 Getting the previous date of updates
2023-01-26 08:23:00 Last update date: 2023-01-26T00:00:01.000Z
2023-01-26 08:23:00 Getting all updates since last update date and storing them in the database
2023-01-26 08:23:00 -Reading page 0 of 1 from brreg API
2023-01-26 08:23:00 --Added 93 changes to oppdaterteEnheter table
2023-01-26 08:23:00 update shadow database with changes
2023-01-26 08:23:00 1 Sletting endringstype organisasjonsnummer=898395332
2023-01-26 08:23:00 1 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 2 Sletting endringstype organisasjonsnummer=912004104
2023-01-26 08:23:00 2 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 3 Sletting endringstype organisasjonsnummer=914397871
2023-01-26 08:23:00 3 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 4 Sletting endringstype organisasjonsnummer=918287795
2023-01-26 08:23:00 4 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 5 Sletting endringstype organisasjonsnummer=919085940
2023-01-26 08:23:00 5 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 6 Sletting endringstype organisasjonsnummer=919221046
2023-01-26 08:23:00 6 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 7 Sletting endringstype organisasjonsnummer=919625481
2023-01-26 08:23:00 7 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 8 Sletting endringstype organisasjonsnummer=925554316
2023-01-26 08:23:00 8 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 9 Sletting endringstype organisasjonsnummer=925985554
2023-01-26 08:23:00 9 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 10 Sletting endringstype organisasjonsnummer=926052152
2023-01-26 08:23:00 10 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 11 Sletting endringstype organisasjonsnummer=927220687
2023-01-26 08:23:00 11 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 12 Sletting endringstype organisasjonsnummer=927327597
2023-01-26 08:23:00 12 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 13 Sletting endringstype organisasjonsnummer=927528398
2023-01-26 08:23:00 13 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 14 Sletting endringstype organisasjonsnummer=927913135
2023-01-26 08:23:00 14 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 15 Sletting endringstype organisasjonsnummer=928225097
2023-01-26 08:23:00 15 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 16 Sletting endringstype organisasjonsnummer=929449851
2023-01-26 08:23:00 16 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 17 Sletting endringstype organisasjonsnummer=929636236
2023-01-26 08:23:00 17 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 18 Sletting endringstype organisasjonsnummer=969830647
2023-01-26 08:23:00 18 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 19 Sletting endringstype organisasjonsnummer=983476589
2023-01-26 08:23:00 19 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 20 Sletting endringstype organisasjonsnummer=986765565
2023-01-26 08:23:00 20 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 21 Sletting endringstype organisasjonsnummer=823778732
2023-01-26 08:23:00 21 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 22 Sletting endringstype organisasjonsnummer=916231296
2023-01-26 08:23:00 22 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 23 Sletting endringstype organisasjonsnummer=920320295
2023-01-26 08:23:00 23 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 24 Sletting endringstype organisasjonsnummer=921879989
2023-01-26 08:23:00 24 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 25 Sletting endringstype organisasjonsnummer=923085599
2023-01-26 08:23:00 25 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 26 Sletting endringstype organisasjonsnummer=923963359
2023-01-26 08:23:00 26 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 27 Sletting endringstype organisasjonsnummer=925739537
2023-01-26 08:23:00 27 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 28 Sletting endringstype organisasjonsnummer=929095340
2023-01-26 08:23:00 28 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 29 Sletting endringstype organisasjonsnummer=958090641
2023-01-26 08:23:00 29 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 30 Sletting endringstype organisasjonsnummer=959829446
2023-01-26 08:23:00 30 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 31 Sletting endringstype organisasjonsnummer=981686365
2023-01-26 08:23:00 31 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 32 Sletting endringstype organisasjonsnummer=986645519
2023-01-26 08:23:00 32 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 33 Endring endringstype organisasjonsnummer=929668642
2023-01-26 08:23:00 33 Updated the brreg_enheter_alle table
2023-01-26 08:23:00 Updated the oppdaterte_enheter table
2023-01-26 08:23:00 34 Endring endringstype organisasjonsnummer=920152309
2023-01-26 08:23:01 34 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 35 Endring endringstype organisasjonsnummer=926071963
2023-01-26 08:23:01 35 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 36 Sletting endringstype organisasjonsnummer=990513074
2023-01-26 08:23:01 36 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 37 Sletting endringstype organisasjonsnummer=856291472
2023-01-26 08:23:01 37 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 38 Endring endringstype organisasjonsnummer=924548436
2023-01-26 08:23:01 38 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 39 Endring endringstype organisasjonsnummer=927427990
2023-01-26 08:23:01 39 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 40 Endring endringstype organisasjonsnummer=929584619
2023-01-26 08:23:01 40 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 41 Endring endringstype organisasjonsnummer=930131342
2023-01-26 08:23:01 41 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 42 Endring endringstype organisasjonsnummer=915078508
2023-01-26 08:23:01 42 Updated the brreg_enheter_alle table
2023-01-26 08:23:01 Updated the oppdaterte_enheter table
2023-01-26 08:23:01 43 Endring endringstype organisasjonsnummer=987450665
2023-01-26 08:23:02 43 Updated the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 44 Endring endringstype organisasjonsnummer=889579552
2023-01-26 08:23:02 44 Updated the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 45 Sletting endringstype organisasjonsnummer=925547492
2023-01-26 08:23:02 45 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 46 Sletting endringstype organisasjonsnummer=929968492
2023-01-26 08:23:02 46 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 47 Endring endringstype organisasjonsnummer=998577470
2023-01-26 08:23:02 47 Not found in the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 48 Endring endringstype organisasjonsnummer=926942638
2023-01-26 08:23:02 48 Updated the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 49 Endring endringstype organisasjonsnummer=928306518
2023-01-26 08:23:02 49 Updated the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 50 Sletting endringstype organisasjonsnummer=986328025
2023-01-26 08:23:02 50 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 51 Endring endringstype organisasjonsnummer=924828099
2023-01-26 08:23:02 51 Updated the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 52 Endring endringstype organisasjonsnummer=881714922
2023-01-26 08:23:02 52 Updated the brreg_enheter_alle table
2023-01-26 08:23:02 Updated the oppdaterte_enheter table
2023-01-26 08:23:02 53 Endring endringstype organisasjonsnummer=920934803
2023-01-26 08:23:03 53 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 54 Endring endringstype organisasjonsnummer=989247840
2023-01-26 08:23:03 54 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 55 Endring endringstype organisasjonsnummer=946030961
2023-01-26 08:23:03 55 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 56 Endring endringstype organisasjonsnummer=966679840
2023-01-26 08:23:03 56 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 57 Endring endringstype organisasjonsnummer=989226282
2023-01-26 08:23:03 57 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 58 Endring endringstype organisasjonsnummer=989250337
2023-01-26 08:23:03 58 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 59 Endring endringstype organisasjonsnummer=923441271
2023-01-26 08:23:03 59 Updated the brreg_enheter_alle table
2023-01-26 08:23:03 Updated the oppdaterte_enheter table
2023-01-26 08:23:03 60 Endring endringstype organisasjonsnummer=971130954
2023-01-26 08:23:04 60 Updated the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 61 Endring endringstype organisasjonsnummer=971130989
2023-01-26 08:23:04 61 Updated the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 62 Endring endringstype organisasjonsnummer=968583301
2023-01-26 08:23:04 62 Updated the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 63 Endring endringstype organisasjonsnummer=923535551
2023-01-26 08:23:04 63 Updated the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 64 Endring endringstype organisasjonsnummer=991780696
2023-01-26 08:23:04 64 Updated the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 65 Sletting endringstype organisasjonsnummer=992981105
2023-01-26 08:23:04 65 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 66 Endring endringstype organisasjonsnummer=928821242
2023-01-26 08:23:04 66 Updated the brreg_enheter_alle table
2023-01-26 08:23:04 Updated the oppdaterte_enheter table
2023-01-26 08:23:04 67 Ny endringstype organisasjonsnummer=930718785
2023-01-26 08:23:05 67 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 68 Ny endringstype organisasjonsnummer=930718815
2023-01-26 08:23:05 68 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 69 Ny endringstype organisasjonsnummer=930718904
2023-01-26 08:23:05 69 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 70 Endring endringstype organisasjonsnummer=911968215
2023-01-26 08:23:05 70 Updated the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 71 Endring endringstype organisasjonsnummer=830582622
2023-01-26 08:23:05 71 Updated the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 72 Endring endringstype organisasjonsnummer=930600962
2023-01-26 08:23:05 72 Updated the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 73 Endring endringstype organisasjonsnummer=930607169
2023-01-26 08:23:05 73 Updated the brreg_enheter_alle table
2023-01-26 08:23:05 Updated the oppdaterte_enheter table
2023-01-26 08:23:05 74 Ny endringstype organisasjonsnummer=930719161
2023-01-26 08:23:06 74 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 75 Ny endringstype organisasjonsnummer=930337595
2023-01-26 08:23:06 75 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 76 Ny endringstype organisasjonsnummer=830719172
2023-01-26 08:23:06 76 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 77 Ny endringstype organisasjonsnummer=930719242
2023-01-26 08:23:06 77 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 78 Ny endringstype organisasjonsnummer=930719293
2023-01-26 08:23:06 78 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 79 Endring endringstype organisasjonsnummer=988894907
2023-01-26 08:23:06 79 Updated the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 80 Sletting endringstype organisasjonsnummer=921017278
2023-01-26 08:23:06 80 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 81 Ny endringstype organisasjonsnummer=930719447
2023-01-26 08:23:06 81 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:06 Updated the oppdaterte_enheter table
2023-01-26 08:23:06 82 Endring endringstype organisasjonsnummer=999257178
2023-01-26 08:23:07 82 Not found in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 83 Ny endringstype organisasjonsnummer=930719595
2023-01-26 08:23:07 83 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 84 Ny endringstype organisasjonsnummer=930719617
2023-01-26 08:23:07 84 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 85 Ny endringstype organisasjonsnummer=930719560
2023-01-26 08:23:07 85 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 86 Sletting endringstype organisasjonsnummer=917343373
2023-01-26 08:23:07 86 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 87 Endring endringstype organisasjonsnummer=829197332
2023-01-26 08:23:07 87 Updated the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 88 Sletting endringstype organisasjonsnummer=922077371
2023-01-26 08:23:07 88 Marked the organization Slettet in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 89 Ny endringstype organisasjonsnummer=830719652
2023-01-26 08:23:07 89 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 90 Ny endringstype organisasjonsnummer=929723007
2023-01-26 08:23:07 90 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:07 Updated the oppdaterte_enheter table
2023-01-26 08:23:07 91 Endring endringstype organisasjonsnummer=922835985
2023-01-26 08:23:08 91 Updated the brreg_enheter_alle table
2023-01-26 08:23:08 Updated the oppdaterte_enheter table
2023-01-26 08:23:08 92 Endring endringstype organisasjonsnummer=981377028
2023-01-26 08:23:08 92 Updated the brreg_enheter_alle table
2023-01-26 08:23:08 Updated the oppdaterte_enheter table
2023-01-26 08:23:08 93 Ny endringstype organisasjonsnummer=930718653
2023-01-26 08:23:08 93 Created the organization in the brreg_enheter_alle table
2023-01-26 08:23:08 Updated the oppdaterte_enheter table
2023-01-26 08:23:08 Done for today
2023-01-26 08:23:18 shadow-cron.sh finished
```

## Second run stared one minute later

```
2023-01-26 08:24:00 shadow-cron.sh started
2023-01-26 08:24:00 Database ready, starting shadow app
2023-01-26 08:24:00 All database variables are set
2023-01-26 08:24:00 Testing db connection ... dateNow:  2023-01-26T07:24:00.466Z
2023-01-26 08:24:00 Database connection is ok
2023-01-26 08:24:00 Getting the previous date of updates
2023-01-26 08:24:00 Last update date: 2023-01-26T07:22:22.875Z
2023-01-26 08:24:00 Getting all updates since last update date and storing them in the database
2023-01-26 08:24:00 -Reading page 0 of 1 from brreg API
2023-01-26 08:24:00 --Added 0 changes to oppdaterteEnheter table
2023-01-26 08:24:00 update shadow database with changes
2023-01-26 08:24:00 Done for today
2023-01-26 08:24:10 shadow-cron.sh finished
```

## Third run started one minute later

```
2023-01-26 08:25:00 shadow-cron.sh started
2023-01-26 08:25:00 Database ready, starting shadow app
2023-01-26 08:25:00 All database variables are set
2023-01-26 08:25:00 Testing db connection ... dateNow:  2023-01-26T07:25:00.396Z
2023-01-26 08:25:00 Database connection is ok
2023-01-26 08:25:00 Getting the previous date of updates
2023-01-26 08:25:00 Last update date: 2023-01-26T07:22:22.875Z
2023-01-26 08:25:00 Getting all updates since last update date and storing them in the database
2023-01-26 08:25:00 -Reading page 0 of 1 from brreg API
2023-01-26 08:25:00 --Added 1 changes to oppdaterteEnheter table
2023-01-26 08:25:00 update shadow database with changes
2023-01-26 08:25:00 1 Ny endringstype organisasjonsnummer=830719792
2023-01-26 08:25:00 1 Created the organization in the brreg_enheter_alle table
2023-01-26 08:25:00 Updated the oppdaterte_enheter table
2023-01-26 08:25:00 Done for today
2023-01-26 08:25:10 shadow-cron.sh finished

```
# Converting and importing a 1 GB JSON file into a Postgres database

In this article, I'll show you how to convert a large JSON file to a CSV file, then import the CSV file into a PostgreSQL database table.
![An oil painting by Matisse of a humanoid robot putting a large file into a database](../../img/dall-e_robot_file_into_db.png)

## Why is it necessary to convert the JSON to a CSV file before importing it into Postgres?

Postgres has very good support for CVS data. Importing a CVS file into a table can be done with a single command, and it is lightning fast.

JSON is the native data structure for JavaScript and node. Normally, you can just read the JSON and output it in the format you want. But when the JSON file is 1 GB or more, it is not possible to read it into memory. So you have to use a streaming parser to read the JSON file. In this example, I will use the json2csv library to convert the JSON file to a CSV file. In this example I will use the [json2csv library](https://juanjodiaz.github.io/json2csv) to convert the JSON file to a CSV file.

I obtained the JSON file from the [Brønnøysundregistrene](https://data.brreg.no/enhetsregisteret/api/docs/index.html) The Enhetsregisteret JSON file contains all organizations in Norway. It has 1.097.489 records, and the uncompressed file size is 1.1 GB. You can [download the compressed file here](https://data.brreg.no/enhetsregisteret/api/enheter/lastned) the file size is 90 MB.

You have to decompress the `enheter_alle.json.gz` you downloaded from Brønnøysundregistrene.
```bash
gunzip enheter_alle.json.gz
```
You now have a file named `enheter_alle.json` that is 1.1 GB.

## Preprosessing the JSON file

If your JSON file has fields that are arrays, you can run into trouble if you are using the comma "," as the delimiter in the CSV file. The conversion to CVS might be OK, but when you import the CSV file to the database, you might run into problems. In the `enheter_alle.json` file, a field named `"adresse"` is an array of strings. In most cases, it contains one string, but it can also have more than one. Eg:

```json
"adresse": "[""c/o 1Bedrift.no AS"",""Hasleveien 28A""]",
"adresse" : "[ "Nebbaveien 39" ]"
```

When converting to CSV we will have line like this:
```csv
hjemmeside,postadresse_adresse,postadresse_poststed
"","[""c/o 1Bedrift.no AS"",""Hasleveien 28A""]","OSLO"
```

When importing the CSV file to Postgres the "adresse" field will be split into two fields. The first field will be "postadresse_adresse" and the second field will be "postadresse_poststed". This is not what we want.

This means that we cannot use "," as the delimiter in the CSV file. How big is the problem? List all uses of the comma "," inside quotes in the file enheter_alle.json

```bash
awk '/,"/{print}' enheter_alle.json
```

As we can see, there are a lot of fields that contain a comma "," inside. Let's see if we can use the pipe symbol "|". This command lists all uses of "|" in the file enheter_alle.json

```bash
awk '/\|/{print}' enheter_alle.json
```

It seems that the use of the pipe symbol "|" is more like a typing mistake. These are all the lines that contain a pipe symbol. Not many, considering the size of the file.

```bash
    "adresse" : [ "Postboks 416  |" ],
    "adresse" : [ "Postboks 381  |" ],
    "adresse" : [ "Trinity House|31 Lynedoch Street" ]
    "adresse" : [ "c/o Clemens Kraft AS|", "Fridtjof Nansens plass 6" ],
    "poststed" : "SE-|164 40 KISTA",
    "adresse" : [ "c/o Jan Stadven |", "Nebbaveien 39" ],
    "adresse" : [ "ulitsa Knyaz Boris | 8 ap. 1" ]
    "poststed" : "DE-22767|",
    "adresse" : [ "c/o Enqvist Boligforvaltning AS", "Postboks 6653 Rodeløkka|" ],
    "adresse" : [ "Mölndalsvägen 25|" ]
    "adresse" : [ "Kontinentalveien 22|" ],
    "adresse" : [ "Dexter Avenue North (4th Floor)|" ]
    "adresse" : [ "Hagattu 75 Svedjan||" ]
  "hjemmeside" : "www.|absoluteinteractive.no",
  "hjemmeside" : "ifmsa.no/index.php?path=4|39",
    "adresse" : [ "Carpenter Court", "1 Maple Road Bramhall Stockport|" ]
    "adresse" : [ "c/o |Geir Utmo" ],
    "poststed" : "80049 SOMMA VESUVIANA (NA)|",
```

Create a new json file where we strip out the "|". This way we have a safe delimiter.
```bash
awk '{gsub(/\|/,"")}1' enheter_alle.json > enheter_alle_nopipe.json
````

*I do not like that we change the data.  And I have tried to evade the problem by using a delimiter that is not used in the JSON file. Eg: "¦" or "®". And then tell psql database import to use the DELIMITER E'\266' option. But then we might run into problems related to the character set for the database.*

## Converting the preprocessed JSON file to a CSV file

We will use the command-line version (cli) of the json2csv library. It does basic mapping and conversion of the JSON file to a CSV file.
Install the json2csv cli library and check if it is installed correctly:

```bash
npm install -g @json2csv/cli
npm install -g @json2csv/transforms
json2csv --help
```

### Mapping the JSON file to the CSV file

Brreg.no has a Microsoft Excel verison of the Enhetsregisteret for download. The field names in the excel file and in the JSON file are not the same. So we need to map the fields in the JSON file so that it matches the field names in the excel file. My configuration file is named `json2csv-config.json`. You can find the [file I use here](https://github.com/terchris/shadow-brreg/blob/main/app/shadow/json2csv-config.json )

In the configuration file you define the fields you want to have in the CSV file. If a field is not defined, it will not be included. So you must know the fields and structure in the JSON file you want to import.
In the case of Enhetsregisteret, the number of fields on a JSON record varies from record to record. Some records have a field, and some do not.

To find all fields, consult the JSON documentation. If there is no documentation, you need to analyze the JSON file and identify all fields.

Two example fields in the Enhetsregisteret JSON record:

```json
{
    "organisasjonsnummer": "819439842",
    "navn": "SMARTE BYER NORGE AS",
}
```

*(To see all fields for this company you can do a lookup in the brreg.no API here [SMARTE BYER NORGE AS](https://data.brreg.no/enhetsregisteret/api/enheter/819439842 ) )*

To extract this into the CSV file, we need to define the fields in the configuration file. Structure of the json2csv-config.json file:

```json
{
    "fields": [
        {
            "label": "OrganisationNumber",
            "value": "organisasjonsnummer"
        },
        {
            "label": "Name",
            "value": "navn"
        }
    ]
}
```

The "label" is the name of the field in the CSV file. The "value" is the name of the field in the JSON file.

To extract fields in objects you can use the dot notation. For example to extract the "poststed" field from the JSON record you can use the following configuration:

```json
{
    "fields": [
        {
            "label": "postadresse_adresse",
            "value": "postadresse.adresse",
            "default": "there is no adresse"
        }
    ]
}
```

The "default" field is used if the field is not defined in the JSON record. If there is no "default" field, then the "label" field will be empty in the CSV file.
Use the json2csv library to convert the JSON file to a CSV file:

### Converting the JSON file to a CSV file

The json2csv command will convert the file and save it as a CSV file to disk using the pipe symnbol as delimiter. The CSV file size should be around 350 MB. The command is:

```bash
json2csv -i enheter_alle.json -o enheter_alle.csv -d "|" -c json2csv-config.json
```

 i = input file, o = output file, d = delimiter, c = configuration file

## Importing the CSV file into a PostgreSQL database

The CSV file can be imported into Postgres with the following command:

```bash
PGPASSWORD="postgres" psql -h "db" -p "5433" -U "postgres" -d "importdata" -c "\copy brreg_enheter_alle FROM enheter_alle.csv WITH DELIMITER '|' CSV HEADER;"
```

Replace the variables with your values. You must have created the table before you can import the data.

The import is fast and reliable.

### Check that the data is OK

List the first 10 rows in the table brreg_enheter_alle where the postadresse_adresse contains a comma ","

```bash
PGPASSWORD="postgres" psql -h "db" -p "5433" -U "postgres" -d "importdata" -c "SELECT navn, postadresse_adresse FROM brreg_enheter_alle WHERE postadresse_adresse LIKE '%,%' LIMIT 10;"
```

Thats it. You've just converted a large JSON file to a CSV file and imported it into a PostgreSQL database table. If you want to play around with this example, you can find the code in my [shadow-brreg repository](https://github.com/terchris/shadow-brreg )

---
Some handy commands I used when dealing with the files and testing the import

Print the line that contains the string 930163686 in the file enheter_alle.csv

```bash
awk '/930163686/{print}' enheter_alle.csv
````

Extract the header column from the csv file and add one record to the file (usefull for testing the import)

```bash
awk 'NR==1' enheter_alle.csv > enheter_one.csv
awk '/930163686/{print}' enheter_alle.csv  >> enheter_one.csv
```

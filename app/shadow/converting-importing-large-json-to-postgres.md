# Converting and importing a 1 GB JSON file into a Postgres database

In this article, I'll show you how to convert a large JSON file to a CSV file, then import the CSV file into a PostgreSQL database table.
![An oil painting by Matisse of a humanoid robot putting a large file into a database](../../img/dall-e_robot_file_into_db.png)

## Why is it necessary to convert the JSON to a CSV file before importing it into Postgres?

Postgres has very good support for CVS data. Importing a CVS file into a table can be done with a single command, and it is lightning fast.

JSON is the native data structure for JavaScript and nodes. Normally, you can just read the JSON and output it in the format you want. But when the JSON file is 1 GB or more, it is not possible to read it into memory. So you have to use a streaming parser to read the JSON file. In this example, I will use the json2csv library to convert the JSON file to a CSV file. In this example I will use the [json2csv library](https://juanjodiaz.github.io/json2csv) to convert the JSON file to a CSV file.

I obtained the JSON file from the [Brønnøysundregistrene](https://data.brreg.no/enhetsregisteret/api/docs/index.html) The Enhetsregisteret JSON file contains all organizations in Norway. It has 1.097.489 records, and the uncompressed file size is 1.1 GB. You can [download the compressed file here](https://data.brreg.no/enhetsregisteret/api/enheter/lastned) the file size is 90 MB.

You have to decompress the `enheter_alle.json.gz` you downloaded from Brønnøysundregistrene.
```bash
gunzip enheter_alle.json.gz
```

We will use the command-line version (cli) of the json2csv library. It does basic mapping and conversion of the JSON file to a CSV file. It does not support transformations. So if you need to do transformations, you have to use the library in your code.

Install the json2csv cli library and check if the json2csv is installed correctly:
```bash
npm install -g @json2csv/cli
npm install -g @json2csv/transforms
json2csv --help
```

## Mapping the JSON file to the CSV file

Brreg.no has a M$ Excel verison of the Enhetsregisteret for download. The field names in the excel file and in the JSON file are not the same. So we need to map the fields in the JSON file so that it matches the field names in the excel file. My configuration file is named `json2csv-config.json`. You can find the [file I use here](https://github.com/terchris/shadow-brreg/blob/main/app/shadow/json2csv-config.json )

You tell json2csv which fields to include in the CSV file when you use a configuration file. If a field is not defined in the configuration file, it will not be included in the CSV file. So you must know the fields and structure in the JSON file you want to import.
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

The "default" field is used if the field is not defined in the JSON record. If you do not define the "default" field, the field will be empty in the CSV file.

Use the json2csv library to convert the JSON file to a CSV file:
```bash
json2csv -i enheter_alle.json -o enheter_alle.csv -c json2csv-config.json
```
 i = input file, o = output file, c = configuration file

The json2csv command will convert the file and save it as a CSV file to disk. The CSV file size should be around 350 MB. The CSV file can be imported into Postgres with the following command:
```bash
  PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "\copy $BRREGENHETERTABLENAME FROM enheter_alle.csv DELIMITER ',' CSV HEADER;"
```

Replace the variables with your values. The $BRREGENHETERTABLENAME is the name of the table you want to import the data into. You must have created the table before you can import the data.

The import is fast and reliable.

Thats it. You've just converted a large JSON file to a CSV file and imported it into a PostgreSQL database table. If you want to play around with this example, you can find the code in my [shadow-brreg repository](https://github.com/terchris/shadow-brreg )

NB! You need node installed to run the example.
# notes on converting json to csv 

This is the lib for converting top json to csv:
https://juanjodiaz.github.io/json2csv/#/parsers/cli



The cli does not have the best doc. So there was a lot of trial and error to get it to work.
The key is to inderstand the -c config parameter and set up the condig file.
The config file defines the mapping of the fields. The file is named json2csv-config.json 

I have mapped the fields so that the result is the same as when using the M$ excel file.

The problem with the excel file is that the field adresse is not converted correctly. The excel file takes the first sting in the adresse field.
This causes problems for the examples you see below:

    "forretningsadresse" : {
    "land" : "Norge",
    "landkode" : "NO",
    "postnummer" : "0580",
    "poststed" : "OSLO",
    "adresse" : [ "c/o Anders Abrahamsen", "Risløkkveien 23E" ],
    "kommune" : "OSLO",
    "kommunenummer" : "0301"
  },
    "postadresse" : {
    "land" : "Norge",
    "landkode" : "NO",
    "postnummer" : "6280",
    "poststed" : "SØVIK",
    "adresse" : [ "c/o Ivar Martin Søviknes", "Solheimsvegen 16" ],
    "kommune" : "ÅLESUND",
    "kommunenummer" : "1507"
  },


  Now the adresse fileds in the database contains the array of strings.
  eg:
forretningsadresse_adresse = [ "c/o Anders Abrahamsen", "Risløkkveien 23E" ]
postadresse_adresse = [ "c/o Ivar Martin Søviknes", "Solheimsvegen 16" ]



Another thing is that the excel file has a field named "hjelpeenhetskode" and  "Hjelpeenhetskode_beskrivelse" which is not in the json file.
In the json file there is a field named "hjelpeenhetskode" which is a boolean.
  "naeringskode2" : {
    "beskrivelse" : "Uoppgitt",
    "kode" : "00.000",
    "hjelpeenhetskode" : true
  },

Not sure how to handle this. I have mapped the hjelpeenhetskode to the hjelpeenhetskode_beskrivelse fields to be the same as naeringskode2.

The json2csv can do transformations. And I was thinking that I could use the transformation to fill in "hjelpeenhetskode" and  "Hjelpeenhetskode_beskrivelse" only when the hjelpeenhetskode is true.
But json2csv does not support transformatuions when using the command line (cli) - so I skipped it.

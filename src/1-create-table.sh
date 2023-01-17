# 1-create-table
# creates the database table brreg_enheter_alle
# notice that postgres is running on port 5433
# Usage: 1-create-table.sh 


psql -p 5433 -d importdata --user=postgres -c "CREATE TABLE brreg_enheter_alle (
  Organisasjonsnummer VARCHAR(10),
  Navn VARCHAR(255) NOT NULL,
  Organisasjonsform_kode VARCHAR(10) NOT NULL,
  Organisasjonsform_beskrivelse VARCHAR(255) NOT NULL,
  Naringskode_1 VARCHAR(10),
  Naringskode_1_beskrivelse VARCHAR(255),
  Naringskode_2 VARCHAR(10),
  Naringskode_2_beskrivelse VARCHAR(255),
  Naringskode_3 VARCHAR(10),
  Naringskode_3_beskrivelse VARCHAR(255),
  Hjelpeenhetskode VARCHAR(10),
  Hjelpeenhetskode_beskrivelse VARCHAR(255),
  Antall_ansatte INTEGER,
  Hjemmeside VARCHAR(255),
  Postadresse_adresse VARCHAR(255),
  Postadresse_poststed VARCHAR(255),
  Postadresse_postnummer VARCHAR(10),
  Postadresse_kommune VARCHAR(255),
  Postadresse_kommunenummer VARCHAR(10),
  Postadresse_land    VARCHAR(20),
  Postadresse_landkode    VARCHAR(10),
  Forretningsadresse_adresse  VARCHAR(255),
  Forretningsadresse_poststed VARCHAR(255),
  Forretningsadresse_postnummer VARCHAR(10),
  Forretningsadresse_kommune VARCHAR(20),
  Forretningsadresse_kommunenummer    VARCHAR(10),
  Forretningsadresse_land VARCHAR(20),
  Forretningsadresse_landkode VARCHAR(10),
  Institusjonell_sektorkode   VARCHAR(10),
  Institusjonell_sektorkode_beskrivelse   VARCHAR(255),
  Siste_innsendte_arsregnskap VARCHAR(20),
  Registreringsdato_i_Enhetsregisteret    VARCHAR(20),
  Stiftelsesdato  VARCHAR(20),
  FrivilligRegistrertIMvaregisteret       VARCHAR(10),
  Registrert_i_MVA_registeret VARCHAR(10),
  Registrert_i_Frivillighetsregisteret VARCHAR(10),  
  Registrert_i_Foretaksregisteret     VARCHAR(10),
  Registrert_i_Stiftelsesregisteret   VARCHAR(10),
  Konkurs VARCHAR(10),
  Under_avvikling VARCHAR(10),
  Under_tvangsavvikling_eller_tvangsopplasning    VARCHAR(10),
  Overordnet_enhet_i_offentlig_sektor   VARCHAR(50),
  Malform VARCHAR(10),
  PRIMARY KEY (Organisasjonsnummer)
  );"


# get table definition from dag.urbalurba.no
pg_dump -s -t brreg_enheter_alle -d importdata -U strapi -W > brreg_enheter_alle-table_definition.sql



# drop the table inside docker container
PGPASSWORD="postgres" psql -p 5433 -d importdata --user=postgres -c "DROP TABLE brreg_enheter_alle;"

# create the table inside docker container
PGPASSWORD="postgres" psql -p 5433 -U postgres -d importdata -f brreg_enheter_alle-table_definition.sql

PGPASSWORD="postgres" psql -p 5433 -U postgres -d importdata -f brreg_enheter_alle-table_definition.sql
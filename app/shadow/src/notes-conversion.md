# notes on converting json to csv 

This is the lib for converting top json to csv:
https://juanjodiaz.github.io/json2csv/#/parsers/cli

json2csv -i lastned.json -o lastned-json2csv.csv --flatten-objects --flatten-separator "_"

This creates the following header row:

Field names:
"organisasjonsnummer","navn","organisasjonsform_kode","organisasjonsform_beskrivelse","postadresse_land","postadresse_landkode","postadresse_postnummer","postadresse_poststed","postadresse_adresse","postadresse_kommune","postadresse_kommunenummer","registreringsdatoEnhetsregisteret","registrertIMvaregisteret","naeringskode1_beskrivelse","naeringskode1_kode","naeringskode2_beskrivelse","naeringskode2_kode","naeringskode3_beskrivelse","naeringskode3_kode","forretningsadresse_land","forretningsadresse_landkode","forretningsadresse_postnummer","forretningsadresse_poststed","forretningsadresse_adresse","forretningsadresse_kommune","forretningsadresse_kommunenummer","stiftelsesdato","institusjonellSektorkode_kode","institusjonellSektorkode_beskrivelse","registrertIForetaksregisteret","registrertIStiftelsesregisteret","registrertIFrivillighetsregisteret","sisteInnsendteAarsregnskap","konkurs","underAvvikling","underTvangsavviklingEllerTvangsopplosning","maalform"

These fileld names defines the table in the function createShadowbrregJson

    const queryString = `CREATE TABLE shadowbrreg_json (
        organisasjonsnummer TEXT PRIMARY KEY,
        navn TEXT NOT NULL,
        organisasjonsform_kode TEXT,
        organisasjonsform_beskrivelse TEXT,
        naeringskode1_kode TEXT,
        naeringskode1_beskrivelse TEXT,
        naeringskode2_kode TEXT,
        naeringskode2_beskrivelse TEXT,
        naeringskode3_kode TEXT,
        naeringskode3_beskrivelse TEXT,
        hjelpeenhetskode TEXT,
        hjelpeenhetskode_beskrivelse TEXT,
        antall_ansatte INTEGER,
        hjemmeside TEXT,
        postadresse_adresse TEXT,
        postadresse_poststed TEXT,
        postadresse_postnummer TEXT,
        postadresse_kommune TEXT,
        postadresse_kommunenummer TEXT,
        postadresse_land TEXT,
        postadresse_landkode TEXT,
        forretningsadresse_adresse TEXT,
        forretningsadresse_poststed TEXT,
        forretningsadresse_postnummer TEXT,
        forretningsadresse_kommune TEXT,
        forretningsadresse_kommunenummer TEXT,
        forretningsadresse_land TEXT,
        forretningsadresse_landkode TEXT,
        institusjonellSektorkode_kode TEXT,
        institusjonellSektorkode_beskrivelse TEXT,
        sisteInnsendteAarsregnskap TEXT,
        registreringsdatoEnhetsregisteret TEXT,
        stiftelsesdato TEXT,
        registrertIForetaksregisteret TEXT,
        registrertIStiftelsesregisteret TEXT,
        registrertIFrivillighetsregisteret TEXT,
        registrertIMvaregisteret TEXT,
        konkurs TEXT,
        underAvvikling TEXT,
        underTvangsavviklingEllerTvangsopplosning TEXT,
        maalform TEXT,
        slettedato TEXT,
        end_date TEXT,
        urb_brreg_oppdateringsid INTEGER,
        urb_brreg_update_date TIMESTAMP,
        urb_brreg_endringstype VARCHAR(255),
        urb_sync_date TIMESTAMP
    );
    `;

To create a definition file for the table after it is created by the function, use the following command:

pg_dump -p 5433 -U postgres -d importdata -s -t shadowbrreg_json > shadowbrreg_json-table_definition.sql


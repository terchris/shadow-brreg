/** initdb-json.ts
 * for init of the databasewhen importing json files
 */


import pool from './config.js';
import * as dotenv from 'dotenv';

function isDatabaseEnvSet(){

    let envSetOK = false;

    dotenv.config();
    let host = process.env.DATABASE_HOST;
    let port = process.env.DATABASE_PORT ? parseInt(process.env.DATABASE_PORT) : 5433;
    let user = process.env.DATABASE_USER;
    let password = process.env.DATABASE_PASSWORD;
    let database = process.env.DATABASE_NAME;


    if (host && port && user && password && database) {
        envSetOK = true;
    } else {
        console.log("ERROR: Not all database variables are set");
        console.log("host: ", host);
        console.log("port: ", port);
        console.log("user: ", user);
        console.log("password: ", password);
        console.log("database: ", database);
    }

    return envSetOK;
}




async function initiateUrbalurbaStatusJson(): Promise<boolean> {

    let allOK = true;
    try {
        // Check if the table urbalurba_status_json exists
        const res = await pool.query(`SELECT to_regclass('urbalurba_status_json')`);
        const tableExists = res.rows[0].to_regclass;

        if (!tableExists) {
            // Create the table urbalurba_status_json
            await pool.query(`CREATE TABLE urbalurba_status_json (
                database_download_date TIMESTAMP,
                last_brreg_update_date TIMESTAMP,
                last_brreg_oppdateringsid INTEGER,
                id Integer 
            )`);

            // Get the date for when the database was created
            const dbCreateDate = await pool.query(`SELECT (pg_stat_file('base/'||oid ||'/PG_VERSION')).modification
            FROM pg_database
            WHERE datname = 'importdata'`);

            // Change the date to a second past midnight
            const database_download_date = new Date(dbCreateDate.rows[0].modification);
            database_download_date.setUTCHours(0, 0, 1);

            // Insert the date into the urbalurba_status_json table
            await pool.query(`INSERT INTO urbalurba_status_json (database_download_date, id) VALUES ($1, 1)`, [database_download_date]);
            console.log("urbalurba_status_json table is ready and initialized with the date of when the database was created. Witch is: " + database_download_date);
        } else {
            console.log("urbalurba_status_json table already exists");
        }

    } catch (err) {
        console.log(err);
        allOK = false;
    }

    return allOK;
}

async function initiateOppdaterteEnheterJson(): Promise<boolean> {
    try {
        await pool.query(`CREATE TABLE IF NOT EXISTS oppdaterteenheter_json (oppdateringsid INTEGER PRIMARY KEY, dato TIMESTAMP, organisasjonsnummer VARCHAR(255), endringstype VARCHAR(255), urb_processed TIMESTAMP, urb_processed_status VARCHAR(255));`);

        console.log("oppdaterteenheter_json table is ready to receive data");
        return true;
    } catch (err) {
        console.log(err);
        return false;
    }
}


async function tableExist(tableName: string): Promise<boolean> {
    const queryString = `SELECT * FROM information_schema.tables WHERE table_name = '${tableName}'`;
    try {
        const queryResult = await pool.query(queryString);
        if (queryResult.rows.length === 0) {
            return false;
        } else {
            return true;
        }
    } catch (err) {
        console.log(err);
        return false;
    }
}


async function createShadowbrregJson(): Promise<boolean> {

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
        maalform TEXT
    );
    `;   
    try {
        // Check if the fields already exist
        const queryResult = await pool.query(queryString);
        return true;

    } catch (err) {
        console.log(err);
        return false;
    }
}


async function initiateShadowbrregJson() {


    if (isDatabaseEnvSet()) {
        if (await tableExist("shadowbrreg_json")) {
            console.log("shadowbrreg_json table already exists");
        } else {
            let created = await createShadowbrregJson();
            if (created) {
                console.log("shadowbrreg_json table is ready to receive data");
                await initiateUrbalurbaStatusJson();
                await initiateOppdaterteEnheterJson();
                console.log("OK! Tables and fields have been successfully initiated.")
            } else {
                console.log("shadowbrreg_json table could not be created");
            }
        }
    } else {
        console.log("Database environment variables are not set");
    }

}

initiateShadowbrregJson();
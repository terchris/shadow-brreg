/*** initiate-brreg.ts
 * code for initiating the system so that it is ready to receive new data automatically from brreg
 * Written by ChatGPT and @terchris (Copilot was also part of it)
 */

import pool from './config.js';


async function initiateUrbalurbaStatus() {
    try {
        // Check if the table urbalurba_status exists
        const res = await pool.query(`SELECT to_regclass('urbalurba_status')`);
        const tableExists = res.rows[0].to_regclass;

        if (!tableExists) {
            // Create the table urbalurba_status
            await pool.query(`CREATE TABLE urbalurba_status (
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
            database_download_date.setUTCHours(0,0,1);

            // Insert the date into the urbalurba_status table
            await pool.query(`INSERT INTO urbalurba_status (database_download_date, id) VALUES ($1, 1)`, [database_download_date]);
            console.log("urbalurba_status table is ready and initialized with the date of when the database was created. Witch is: " + database_download_date);
        } else {
            console.log("urbalurba_status table already exists");
        }

    } catch (err) {
        console.log(err);
        throw err;
    }
}

async function initiateOppdaterteEnheter() : Promise<boolean> {
    try {
        await pool.query(`CREATE TABLE IF NOT EXISTS oppdaterteEnheter (oppdateringsid INTEGER PRIMARY KEY, dato TIMESTAMP, organisasjonsnummer VARCHAR(255), endringstype VARCHAR(255), urb_processed TIMESTAMP, urb_processed_status VARCHAR(255));`);
        
        console.log("oppdaterteEnheter table is ready to receive data");
        return true;
    } catch (err) {
        console.log(err);
        return false;
    }
}



async function initiateBrregEnheterAlle() {
    try {
        // Check if the fields already exist
        const res = await pool.query(`
            SELECT column_name
            FROM information_schema.columns
            WHERE table_name = 'brreg_enheter_alle'
            AND column_name IN ('urb_brreg_oppdateringsid', 'urb_brreg_update_date', 'urb_brreg_endringstype', 'urb_sync_date');
        `);

        // If the fields don't exist, add them
        if (res.rows.length === 0) {
            await pool.query(`
                ALTER TABLE brreg_enheter_alle
                ADD COLUMN urb_brreg_oppdateringsid INTEGER,
                ADD COLUMN urb_brreg_update_date TIMESTAMP,
                ADD COLUMN urb_brreg_endringstype VARCHAR(255),
                ADD COLUMN urb_sync_date TIMESTAMP;
            `);
            console.log("Fields added successfully to brreg_enheter_alle table");
        } else {
            console.log("Fields already exist in brreg_enheter_alle table");
        }
    } catch (err) {
        console.log(err);
        throw err;
    }
}


async function initiateBrreg() {
    try {
        await initiateUrbalurbaStatus();
        await initiateOppdaterteEnheter();
        await initiateBrregEnheterAlle();
        console.log("OK! Tables and fields have been successfully initiated.")
    } catch (err) {
        console.log(err);
    }
}

initiateBrreg();
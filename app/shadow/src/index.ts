/*** shadow-brreg.ts
 * code for reading changes from brreg and updating the tables
 * Written by ChatGPT and @terchris (Copilot was also part of it)
 * This program will be run as a cronjob 
 * The program does the following:
 * 1. Get the date of the last update from the urbalurba_status table
 * 2. Get the changes from brreg API since the last update
 * 3. Store the changes from the API in the oppdaterteEnheter table
 * 4. for all the changes in the oppdaterteEnheter table: update the brregEnheterAlle table (delete, add or update)
 * 
 */

import pool from './config.js';
import pgFormat from "pg-format";
import axios from 'axios';
import * as dotenv from 'dotenv';
import { IBrregEnheterAlle, IOppdaterteEnheter } from './typedefinitions';

const BrregAPIPageSize = "100";
const changesToProcessForEachRead = 100;
let globalUpdateCounter = 0;


async function getOrganizations(query: string, limit: number): Promise<any[]> {
    try {
        const res = await pool.query(`${query} LIMIT $1`, [limit]);
        return res.rows;
    } catch (err) {
        console.log(err);
        throw err;
    }
}


async function testDatabaseConnection(): Promise<boolean> {
    const numberOfOrganizations = 10;
    const firstOrganizationsQuery = `SELECT * FROM brreg_enheter_alle`;

    let isOK = false;

    dotenv.config();
    let host = process.env.DATABASE_HOST;
    let port = process.env.DATABASE_PORT ? parseInt(process.env.DATABASE_PORT) : 5433;
    let user = process.env.DATABASE_USER;
    let password = process.env.DATABASE_PASSWORD;
    let database = process.env.DATABASE_NAME;


    if (host && port && user && password && database) {
        console.log("All database variables are set");
        let dateNow = new Date();
        console.log("Testing db connection ... dateNow: ", dateNow);
        let firstRecords = await getOrganizations(firstOrganizationsQuery, numberOfOrganizations);

        //if firstRecords are an array then we have a connection to the database
        if (Array.isArray(firstRecords)) {
            console.log("Database connection is ok");
            let isOK = true;
        } else {
            console.log("ERROR: Database connection is not ok");
        }
    } else {
        console.log("ERROR: Not all database variables are set");
        console.log("host: ", host);
        console.log("port: ", port);
        console.log("user: ", user);
        console.log("password: ", password);
        console.log("database: ", database);
    }

    return isOK;
}


async function updateLastDateWeStoredOpdatesFromBrregAPI(lastUpdate: { oppdateringsid: number, dato: string }) {
    try {
        await pool.query(
            `UPDATE urbalurba_status SET last_brreg_update_date = $1, last_brreg_oppdateringsid = $2 WHERE id = 1`,
            [lastUpdate.dato, lastUpdate.oppdateringsid]
        );
    } catch (err) {
        console.log(err);
        throw err;
    }
}



async function getPageOfOppdaterteEnheterFromBrregAPI(dato: string, page: string, size: string): Promise<any> {
    try {
        const response = await axios.get(`https://data.brreg.no/enhetsregisteret/api/oppdateringer/enheter?dato=${dato}&page=${page}&size=${size}`);
        return response.data;
    } catch (error) {
        console.log(error);
        throw error;
    }
}


function findLastUpdateDateAndIdInInputJson(inputJson: any): any {
    const oppdaterteEnheter = inputJson._embedded.oppdaterteEnheter;
    const lastRecord = oppdaterteEnheter[oppdaterteEnheter.length - 1];
    return { oppdateringsid: lastRecord.oppdateringsid, dato: lastRecord.dato };
}


// * 3. Store the changes from the API in the oppdaterteEnheter table
async function addOppdaterteEnheterToDatabase(inputJson: any): Promise<boolean> {
    try {
        const oppdaterteEnheter = inputJson._embedded.oppdaterteEnheter;
        for (const enhet of oppdaterteEnheter) {
            const oppdateringsid = enhet.oppdateringsid;
            // Check if the oppdateringsid already exists in the table
            const res = await pool.query("SELECT oppdateringsid FROM oppdaterteEnheter WHERE oppdateringsid = $1", [oppdateringsid]);
            if (res.rows.length === 0) {
                // oppdateringsid does not exist, insert the record
                const dato = enhet.dato;
                const organisasjonsnummer = enhet.organisasjonsnummer;
                const endringstype = enhet.endringstype;
                await pool.query("INSERT INTO oppdaterteEnheter (oppdateringsid, dato, organisasjonsnummer, endringstype) VALUES ($1, $2, $3, $4)", [oppdateringsid, dato, organisasjonsnummer, endringstype]);
            }
        }

        // updateLastDateWeStoredOpdatesFromBrregAPI
        const lastUpdate = findLastUpdateDateAndIdInInputJson(inputJson);
        await updateLastDateWeStoredOpdatesFromBrregAPI(lastUpdate);

        console.log("--Added " + oppdaterteEnheter.length + " changes to database");
        return true;
    } catch (err) {
        console.log(err);
        return false;
    }
}






// * 1. Get the date of the last update from the urbalurba_status table
async function getLastDateWeStoredOpdatesFromBrregAPI(): Promise<string> {
    try {
        const res = await pool.query(`SELECT database_download_date, last_brreg_update_date FROM urbalurba_status LIMIT 1`);
        const date = res.rows[0].last_brreg_update_date || res.rows[0].database_download_date;
        return date.toISOString();
    } catch (err) {
        console.log(err);
        throw err;
    }
}




//* 2. Get the changes from brreg API since the last update
async function getAllOppdaterteEnheterFromBrregAPI(dato: string, size: string) {
    let page = 0;
    let inputJson = await getPageOfOppdaterteEnheterFromBrregAPI(dato, page.toString(), size);
    while (page < inputJson.page.totalPages) {
        console.log("-Reading page " + page + " of " + inputJson.page.totalPages + " from brreg API");
        await addOppdaterteEnheterToDatabase(inputJson);
        page++;
        inputJson = await getPageOfOppdaterteEnheterFromBrregAPI(dato, page.toString(), size);
    }
}


async function getOneBrregEnhetFromBrregAPI(organisasjonsnummer: string): Promise<{ status: string, enhet?: any, message?: any }> {
    try {
        const response = await axios.get(`https://data.brreg.no/enhetsregisteret/api/enheter/${organisasjonsnummer}`);
        return { status: "success", enhet: response.data };
    } catch (err: any) {
        return { status: "error", message: err.stack };
    }
}


function mapJsonEnhet2db(jsonEnhet: any): any {
    let dbEnhet: any = {};

    dbEnhet.organisasjonsnummer = jsonEnhet.organisasjonsnummer;
    dbEnhet.navn = jsonEnhet.navn;
    dbEnhet.organisasjonsform_kode = jsonEnhet.organisasjonsform.kode ?? null;
    dbEnhet.organisasjonsform_beskrivelse = jsonEnhet.organisasjonsform.beskrivelse ?? null;
    dbEnhet.naringskode_1 = jsonEnhet?.naeringskode1?.kode ?? null;
    dbEnhet.naringskode_1_beskrivelse = jsonEnhet?.naeringskode1?.beskrivelse ?? null;
    dbEnhet.naringskode_2 = jsonEnhet?.naeringskode2?.kode ?? null;
    dbEnhet.naringskode_2_beskrivelse = jsonEnhet?.naeringskode2?.beskrivelse ?? null;
    dbEnhet.naringskode_3 = jsonEnhet?.naeringskode3?.kode ?? null;
    dbEnhet.naringskode_3_beskrivelse = jsonEnhet?.naeringskode3?.beskrivelse ?? null;
    //dbEnhet.hjelpeenhetskode: jsonEnhet.hjelpeenhets.kode,
    //dbEnhet.hjelpeenhetskode_beskrivelse: jsonEnhet.hjelpeenhetskode_beskrivelse,
    dbEnhet.antall_ansatte = jsonEnhet?.antallAnsatte ?? null;
    dbEnhet.hjemmeside = jsonEnhet?.hjemmeside ?? null;
    dbEnhet.postadresse_adresse = jsonEnhet?.postadresse?.adresse[0] ?? null;
    dbEnhet.postadresse_poststed = jsonEnhet?.postadresse?.poststed ?? null;
    dbEnhet.postadresse_postnummer = jsonEnhet?.postadresse?.postnummer ?? null;
    dbEnhet.postadresse_kommune = jsonEnhet?.postadresse?.kommune ?? null;
    dbEnhet.postadresse_kommunenummer = jsonEnhet?.postadresse?.kommunenummer ?? null;
    dbEnhet.postadresse_land = jsonEnhet?.postadresse?.land ?? null;
    dbEnhet.postadresse_landkode = jsonEnhet?.postadresse?.landkode ?? null;
    dbEnhet.forretningsadresse_adresse = jsonEnhet?.forretningsadresse?.adresse[0] ?? null;
    dbEnhet.forretningsadresse_poststed = jsonEnhet?.forretningsadresse?.poststed ?? null;
    dbEnhet.forretningsadresse_postnummer = jsonEnhet?.forretningsadresse?.postnummer ?? null;
    dbEnhet.forretningsadresse_kommune = jsonEnhet?.forretningsadresse?.kommune ?? null;
    dbEnhet.forretningsadresse_kommunenummer = jsonEnhet?.forretningsadresse?.kommunenummer ?? null;
    dbEnhet.forretningsadresse_land = jsonEnhet?.forretningsadresse?.land ?? null;
    dbEnhet.forretningsadresse_landkode = jsonEnhet?.forretningsadresse?.landkode ?? null;
    dbEnhet.institusjonell_sektorkode = jsonEnhet?.institusjonellSektorkode?.kode ?? null;
    dbEnhet.institusjonell_sektorkode_beskrivelse = jsonEnhet?.institusjonellSektorkode?.beskrivelse ?? null;
    dbEnhet.siste_innsendte_arsregnskap = jsonEnhet?.sisteInnsendteAarsregnskap ?? null;
    dbEnhet.registreringsdato_i_enhetsregisteret = jsonEnhet?.registreringsdatoEnhetsregisteret ?? null;
    dbEnhet.stiftelsesdato = jsonEnhet?.stiftelsesdato ?? null;
    dbEnhet.frivilligregistrertimvaregisteret = jsonEnhet?.registrertIFrivillighetsregisteret ?? null;
    dbEnhet.registrert_i_mva_registeret = jsonEnhet?.registrertIMvaregisteret ?? null;
    dbEnhet.registrert_i_frivillighetsregisteret = jsonEnhet?.registrertIFrivillighetsregisteret ?? null;
    dbEnhet.registrert_i_foretaksregisteret = jsonEnhet?.registrertIForetaksregisteret ?? null;
    dbEnhet.registrert_i_stiftelsesregisteret = jsonEnhet?.registrertIStiftelsesregisteret ?? null;
    dbEnhet.konkurs = jsonEnhet?.konkurs ?? null;
    dbEnhet.under_avvikling = jsonEnhet?.underAvvikling ?? null;
    dbEnhet.under_tvangsavvikling_eller_tvangsopplasning = jsonEnhet?.underTvangsavviklingEllerTvangsopplosning ?? null;
    dbEnhet.overordnet_enhet_i_offentlig_sektor = jsonEnhet?.overordnetEnhet ?? null;
    dbEnhet.malform = jsonEnhet?.maalform ?? null;

    return dbEnhet;
}




async function createOneEnhetInBrregShadowDatabase(jsonEnhet: any, jsonUpdate: any): Promise<any> {
    let sql = "";
    try {
        const dbEnhet = mapJsonEnhet2db(jsonEnhet);
        const keys = Object.keys(dbEnhet);
        const values = Object.values(dbEnhet);
        // convert jsonUpdate.dato to ISO format
        const isoDate = new Date(jsonUpdate.dato).toISOString();
        jsonUpdate.dato = isoDate;

        // create the full sql statement using pgFormat
        sql = pgFormat(
            'INSERT INTO brreg_enheter_alle (%I, urb_brreg_oppdateringsid, urb_brreg_update_date, urb_brreg_endringstype) VALUES (%L, %L, %L, %L)',
            keys,
            values,
            jsonUpdate.oppdateringsid,
            jsonUpdate.dato,
            jsonUpdate.endringstype
        );
        // pass the sql statement to the pool.query function
        const result = await pool.query(sql);
        return { status: "success", message: "Brreg enhet was created" };
    } catch (err: any) {
        return { status: "error", message: err.message };
    }
}


async function updateThatWeHaveProcessedTheChange(oppdateringsid: number, status: string): Promise<{ status: string, message?: string }> {
    try {
        const currentDate = new Date();
        const result = await pool.query(`UPDATE oppdaterteenheter SET urb_processed = $1, urb_processed_status = $2 WHERE oppdateringsid = $3`, [currentDate, status, oppdateringsid]);
        if (result.rowCount === 0) {
            return { status: "notfound" };
        }
        return { status: "success" };
    } catch (err: any) {
        return { status: "error", message: err.stack };
    }
}


function logThatWeHaveProcessedTheChange(status: string) {
    switch (status) {
        case "success":
            console.log("Updated the oppdaterte_enheter table");
            break;
        case "error":
            console.log("Error: updating the oppdaterte_enheter table");
            break;
        case "notfound":
            console.log("notfound: Not found in the oppdaterte_enheter table");
            break;
        default:
            console.log("Unknown status");
            break;
    }
}





async function updateOneBrregShadowRecord(jsonEnhet: any, jsonUpdate: any) {
    const dbEnhet = mapJsonEnhet2db(jsonEnhet);
    dbEnhet.urb_brreg_oppdateringsid = jsonUpdate.oppdateringsid;
    // convert date to ISO format
    let theDate = new Date(jsonUpdate.dato);
    dbEnhet.urb_brreg_update_date = theDate.toISOString();
    dbEnhet.urb_brreg_endringstype = jsonUpdate.endringstype;
    let updateQuery = `UPDATE brreg_enheter_alle SET `;
    const keys = Object.keys(dbEnhet);
    const values = Object.values(dbEnhet);
    try {
        const checkOrg = await pool.query(pgFormat("SELECT * FROM brreg_enheter_alle WHERE organisasjonsnummer = %L", jsonEnhet.organisasjonsnummer));
        if (checkOrg.rowCount > 0) {

            keys.forEach((key, i) => {
                if (key !== 'organisasjonsnummer') {
                    updateQuery += pgFormat("%I = %L, ", key, values[i]);
                }
            });

            updateQuery = updateQuery.trim(); // remove ending spaces from updateQuery
            updateQuery = updateQuery.slice(0, -1); // remove ending comma from updateQuery
            updateQuery += pgFormat(" WHERE organisasjonsnummer = %L", jsonEnhet.organisasjonsnummer);
            const updateResult = await pool.query(updateQuery);
            return { status: "success", message: "Organization successfully updated" };
        } else {
            return { status: "notfound", message: "No organization found with that organisasjonsnummer" };
        }
    } catch (err: any) {
        return { status: "error", message: err.stack };
    }
}



async function deleteOneBrregShadowRecord(oppdateringsid: number, dato: string, organisasjonsnummer: string, endringstype: string) {
    let theDate = new Date(dato);
    let theDateISO = theDate.toISOString();
    try {
        const checkOrganizationExist = await pool.query(`SELECT * FROM brreg_enheter_alle WHERE organisasjonsnummer = '${organisasjonsnummer}'`);
        if (checkOrganizationExist.rowCount === 0) {
            return { status: "notfound", message: `No organization with the number ${organisasjonsnummer} was found` };
        } else {
            const updateOrganization = await pool.query(`UPDATE brreg_enheter_alle SET urb_brreg_oppdateringsid = ${oppdateringsid}, urb_brreg_update_date = '${theDateISO}', urb_brreg_endringstype = '${endringstype}' WHERE organisasjonsnummer = '${organisasjonsnummer}'`);
            if (updateOrganization.rowCount === 1) {
                return { status: "success", message: "Organization successfully updated" };
            } else {
                return { status: "error", message: "Failed to update organization" };
            }
        }
    } catch (err: any) {
        return { status: "error", message: err.stack };
    }
}





async function updateOneBrregShadowDatabaseRecord(jsonUpdate: IOppdaterteEnheter) {


    let jsonEnhet: IBrregEnheterAlle;
    let jsonEnhetResponse: {
        status: string;
        enhet?: any;
        message?: any;
    };

    let endringstype = jsonUpdate.endringstype;
    let updateOppdatertEnhetResponse;


    globalUpdateCounter++;

    switch (endringstype) {

        case "Ukjent":
            console.log(globalUpdateCounter + " Ukjent endringstype organisasjonsnummer=" + jsonUpdate.organisasjonsnummer);
            break;
        case "Ny":
            console.log(globalUpdateCounter + " Ny endringstype organisasjonsnummer=" + jsonUpdate.organisasjonsnummer);
            jsonEnhetResponse = await getOneBrregEnhetFromBrregAPI(jsonUpdate.organisasjonsnummer);
            jsonEnhet = jsonEnhetResponse.enhet;
            let createBrregEnhetResponse = await createOneEnhetInBrregShadowDatabase(jsonEnhet, jsonUpdate);

            switch (createBrregEnhetResponse.status) {
                case "success":
                    console.log(globalUpdateCounter + " Created the organization in the brreg_enheter_alle table");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, createBrregEnhetResponse.status);
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;

                case "error":
                    console.log(globalUpdateCounter + " Error creating the organization in the brreg_enheter_alle table");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, createBrregEnhetResponse.status);
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
                case "exists":
                    console.log(globalUpdateCounter + " the organization already exists in the brreg_enheter_alle table");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, createBrregEnhetResponse.status);
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
                default:
                    console.log(globalUpdateCounter + " Unknown status");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, "Unknown status");
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
            }

            break;
        case "Endring":
            console.log(globalUpdateCounter + " Endring endringstype organisasjonsnummer=" + jsonUpdate.organisasjonsnummer);
            jsonEnhetResponse = await getOneBrregEnhetFromBrregAPI(jsonUpdate.organisasjonsnummer);
            switch (jsonEnhetResponse.status) {
                case "success":
                    jsonEnhet = jsonEnhetResponse.enhet;

                    updateOppdatertEnhetResponse = await updateOneBrregShadowRecord(jsonEnhet, jsonUpdate);
                    switch (updateOppdatertEnhetResponse.status) {
                        case "success":
                            console.log(globalUpdateCounter + " Updated the brreg_enheter_alle table");
                            updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, updateOppdatertEnhetResponse.status);
                            logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                            break;

                        case "error":
                            console.log(globalUpdateCounter + " Error updating the brreg_enheter_alle table");
                            updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, updateOppdatertEnhetResponse.status);
                            logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                            break;
                        case "notfound":
                            console.log(globalUpdateCounter + " Not found in the brreg_enheter_alle table");
                            updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, updateOppdatertEnhetResponse.status);
                            logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                            break;
                        default:
                            console.log(globalUpdateCounter + " Unknown status");
                            updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, "Unknown status");
                            logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                            break;
                    }


                    break;
                case "not found":
                    console.log(globalUpdateCounter + " jsonEnhet not found organisasjonsnummer=" + jsonUpdate.organisasjonsnummer);
                    break;
                default:
                    break;
            }

            break;
        case "Sletting":
            console.log(globalUpdateCounter + " Sletting endringstype organisasjonsnummer=" + jsonUpdate.organisasjonsnummer);
            let deleteBrregEnhetResponse = await deleteOneBrregShadowRecord(jsonUpdate.oppdateringsid, jsonUpdate.dato, jsonUpdate.organisasjonsnummer, jsonUpdate.endringstype);

            switch (deleteBrregEnhetResponse.status) {
                case "success":
                    console.log(globalUpdateCounter + " Marked the organization Slettet in the brreg_enheter_alle table");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, deleteBrregEnhetResponse.status);
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
                case "notfound":
                    console.log(globalUpdateCounter + " Organization not found in the brreg_enheter_alle table");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, deleteBrregEnhetResponse.status);
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
                case "Fjernet":
                    console.log(globalUpdateCounter + " Fjernet endringstype");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, deleteBrregEnhetResponse.status);
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
                default:
                    console.log(globalUpdateCounter + " Unknown status");
                    updateOppdatertEnhetResponse = await updateThatWeHaveProcessedTheChange(jsonUpdate.oppdateringsid, "Unknown status");
                    logThatWeHaveProcessedTheChange(updateOppdatertEnhetResponse.status);
                    break;
            }




    }


}


// * 4. for all the changes in the oppdaterteEnheter table: update the brregEnheterAlle table (delete, add or update)
async function updateBrregShadowDatabaseWithChanges(recordsToProcess: number) {


    while (true) {

        try {
            //query to select 10 unprocessed records from oppdaterteenheter table
            const query = `SELECT * FROM oppdaterteenheter WHERE urb_processed IS NULL LIMIT ${recordsToProcess}`;
            const oppdaterteEnheter = await pool.query(query);
            if (oppdaterteEnheter.rowCount === 0) {
                break;
            }

            for (const enhet of oppdaterteEnheter.rows) {
                await updateOneBrregShadowDatabaseRecord(enhet);
            }
        } catch (err: any) {
            console.log("Error in processOppdaterteEnheter: ", err.stack);
        }
    }

}



async function main() {

    let isOK = await testDatabaseConnection();
    if (!isOK) {

        console.log("Getting the previous date of updates");
        let lastUpdateDate = await getLastDateWeStoredOpdatesFromBrregAPI();
        console.log("Last update date: " + lastUpdateDate);

        console.log("Getting all updates since last update date and storing them in the database");
        await getAllOppdaterteEnheterFromBrregAPI(lastUpdateDate, BrregAPIPageSize);

        console.log("update shadow database with changes");
        await updateBrregShadowDatabaseWithChanges(changesToProcessForEachRead)

        console.log("Done for now");
    } else {
        console.log("Database connection is not ok");
    }
}

main();
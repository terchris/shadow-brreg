import pool from './config.js';
import pgFormat from "pg-format";
import axios from 'axios';
import { IBrregEnheterAlle, IOppdaterteEnheter } from './typedefinitions';


async function getOrganizations(query: string, limit: number): Promise<any[]> {
    try {
        const res = await pool.query(`${query} LIMIT $1`, [limit]);
        return res.rows;
    } catch (err) {
        console.log(err);
        throw err;
    }
}

const numberOfOrganizations = 10;
const firstOrganizationsQuery = `SELECT * FROM brreg_enheter_alle`;

async function main() {


    let dateNow = new Date();
    console.log("Testing db connection ... dateNow: ", dateNow);
    let firstRecords = await getOrganizations(firstOrganizationsQuery, numberOfOrganizations);

    //if firstRecords are an array then we have a connection to the database
    if (Array.isArray(firstRecords)) {
        console.log("Database connection is ok");
    } else {
        console.log("ERROR: Database connection is not ok");
    }
}

main();

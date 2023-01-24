import pool from './config.js';
import pgFormat from "pg-format";
import axios from 'axios';
import * as dotenv from 'dotenv';

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


async function testDatabaseConnection() {
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

}


let ok = testDatabaseConnection();

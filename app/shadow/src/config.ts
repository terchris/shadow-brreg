import pg from "pg";
const { Pool } = pg;


import * as dotenv from 'dotenv';

dotenv.config(dotenv.config({ path: '../.env' }));

const pool = new Pool({
    host: process.env.DATABASE_HOST ? "db",
    port: process.env.DATABASE_PORT ? parseInt(process.env.DATABASE_PORT) : 5433,
    user: process.env.DATABASE_USER ? "postgres" : "postgres",
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
});

export default pool;
import 'dotenv/config';
import postgres from 'postgres';

let { PGHOST, PGDATABASE, PGUSER, PGPASSWORD, PGPORT, ENDPOINT_ID } = process.env;

const sql = postgres({
  host: PGHOST,
  database: PGDATABASE,
  username: PGUSER,
  password: PGPASSWORD,
  port: PGPORT,
  ssl: 'require',
  connection: {
    options: `project=${ENDPOINT_ID}`,
  },
});

export default sql;


import promise from 'bluebird';
import pgPromise from 'pg-promise';
import { TenantRepository } from '../src/repository/tenants-repository.js';

const initOptions = {
  promiseLib: promise,
  extend (obj) {
    obj.tenant = new TenantRepository(obj, pgp);
  },
  error (err) {
    console.log(err);
  }
};

const pgp = pgPromise(initOptions);

// Database connection details;
const cn = {
  connectionString: process.env.DB_CONNECTION_STRING
};

const db = pgp(cn); // database instance;
export { db };

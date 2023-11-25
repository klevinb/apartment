export class TenantRepository {
  constructor (db, pgp) {
    this.db = db;
    this.pgp = pgp;
  }

  add ({
    full_name,
    apartment,
    email,
    phone,
    password
  }) {
    return this.db.one(`INSERT INTO tenants(
      full_name, apartment, email, phone, password)
      VALUES ('${full_name}', '${apartment}', '${email}', '${phone}', '${password}')
      RETURNING tenant_id;`);
  }

  get (email) {
    return this.db.oneOrNone(`SELECT
      tenant_id, full_name, apartment, email, phone, password
      FROM tenants WHERE email = '${email}'`);
  }

  delete (email) {
    return this.db.oneOrNone(`DELETE FROM tenants
      WHERE email = '${email}';`);
  }
};

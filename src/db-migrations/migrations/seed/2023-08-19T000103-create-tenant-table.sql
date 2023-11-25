CREATE TABLE Tenants (
  tenant_id SERIAL PRIMARY KEY,
  full_name VARCHAR(30) NOT NULL,
  apartment VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL,
  password VARCHAR(255) NOT NULL,
  contract_started DATE,
  contract_ends DATE,
  last_login TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  is_admin BOOLEAN DEFAULT false
);

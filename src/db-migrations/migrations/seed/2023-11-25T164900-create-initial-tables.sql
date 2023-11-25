-- Task_Types Table
CREATE TABLE Task_Types (
    task_type_id SERIAL PRIMARY KEY,
    task_name VARCHAR(50) UNIQUE NOT NULL
);

-- Tenants Table
CREATE TABLE Tenants (
    tenant_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    personal_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    hashed_password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Apartments Table
CREATE TABLE Apartments (
    apartment_id SERIAL PRIMARY KEY,
    apartment_name VARCHAR(50) UNIQUE NOT NULL,
    landlord_name VARCHAR(100) NOT NULL,
    landlord_address VARCHAR(255) NOT NULL
);

-- Tenant_Roles Table
CREATE TABLE Tenant_Roles (
    tenant_id INT REFERENCES Tenants(tenant_id),
    role VARCHAR(10) CHECK (role IN ('admin', 'tenant')) NOT NULL,
    apartment_id INT REFERENCES Apartments(apartment_id),
    PRIMARY KEY (tenant_id, role)
);

-- Tasks Table
CREATE TABLE Tasks (
    task_id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES Tenants(tenant_id),
    task_type_id INT REFERENCES Task_Types(task_type_id),
    date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contracts Table
CREATE TABLE Contracts (
    contract_id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES Tenants(tenant_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

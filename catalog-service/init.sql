-- CONFIGURE
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DROP
DROP TABLE IF EXISTS products;

-- CREATE
CREATE TABLE products (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name varchar(255) UNIQUE NOT NULL,
    price numeric(2) NOT NULL
);


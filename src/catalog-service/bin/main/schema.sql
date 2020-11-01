-- EXTEND
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DROP
DROP TABLE IF EXISTS products;

-- CREATE
CREATE TABLE products (
    product_id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name varchar(255) UNIQUE NOT NULL,
    price integer NOT NULL
);

-- SEED
INSERT INTO products (name, price)
    VALUES ('prod1', 200), ('prod2', 4000), ('prod3', 2050), ('prod4', 100), ('prod5', 80000), ('prod6', 2001);


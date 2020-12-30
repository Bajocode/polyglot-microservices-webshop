-- EXTEND
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DROP
DROP TABLE IF EXISTS users CASCADE;

-- CREATE
CREATE TABLE users (
    userid uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    email varchar(45) UNIQUE NOT NULL,
    password varchar(255) NOT NULL
);

-- AUTHORIZE
GRANT ALL PRIVILEGES ON TABLE users TO postgres;

-- SEED
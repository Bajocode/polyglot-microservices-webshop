-- EXTEND
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DROP
DROP TABLE IF EXISTS orders CASCADE;

DROP TABLE IF EXISTS order_items CASCADE;

-- CREATE
CREATE TABLE orders (
    orderid uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    userid uuid NOT NULL,
    price integer NOT NULL,
    created bigint NOT NULL
);

CREATE TABLE order_items (
    orderid uuid REFERENCES orders (orderid) ON DELETE CASCADE,
    productid uuid NOT NULL,
    quantity integer NOT NULL,
    price integer NOT NULL,
    PRIMARY KEY (orderid, productid)
);

-- AUTHORIZE
GRANT ALL PRIVILEGES ON TABLE orders TO postgres;

GRANT ALL PRIVILEGES ON TABLE order_items TO postgres;


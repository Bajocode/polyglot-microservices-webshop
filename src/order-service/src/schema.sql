-- EXTEND
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DEREFERENCE
ALTER TABLE orders
    DROP CONSTRAINT orders_userid_fkey;

ALTER TABLE order_items
    DROP CONSTRAINT order_items_orderid_fkey,
    -- DROP
    DROP TABLE IF EXISTS orders;

DROP TABLE IF EXISTS order_items;

-- CREATE
CREATE TABLE orders (
    orderid uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    userid uuid NOT NULL,
    price integer NOT NULL
);

CREATE TABLE order_items (
    orderid uuid REFERENCES orders (orderid) ON DELETE CASCADE,
    productid uuid NOT NULL,
    quantity integer NOT NULL,
    price integer NOT NULL,
    PRIMARY KEY (orderid, productid)
);

-- AUTHORIZE
GRANT ALL PRIVILEGES ON TABLE orders TO admin;

GRANT ALL PRIVILEGES ON TABLE order_items TO admin;

-- SEED
INSERT INTO orders (userid, price)
    VALUES ('85a3a5d5-e50f-463b-a757-9acf5515644a', 200), ('85a3a5d5-e50f-463b-a757-9acf5515644a', 4000);


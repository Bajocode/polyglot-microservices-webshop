-- EXTEND
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- RESET
DROP TABLE IF EXISTS products CASCADE;

DROP TABLE IF EXISTS categories CASCADE;

DROP TABLE IF EXISTS product_categories CASCADE;

-- CREATE
CREATE TABLE products (
    productid uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name varchar(255) UNIQUE NOT NULL,
    price integer NOT NULL DEFAULT 0,
    imagepath varchar(255) UNIQUE NOT NULL,
    created timestamptz NOT NULL DEFAULT NOW()
);

CREATE TABLE categories (
    categoryid integer PRIMARY KEY,
    parentid integer NOT NULL DEFAULT 0,
    name varchar(255) UNIQUE NOT NULL,
    isfinal boolean DEFAULT TRUE,
    created timestamptz NOT NULL DEFAULT NOW()
);

CREATE TABLE product_categories (
    productid uuid REFERENCES products (productid) ON UPDATE CASCADE ON DELETE RESTRICT,
    categoryid integer REFERENCES categories (categoryid) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (productid, categoryid)
);

-- AUTHORIZE
GRANT ALL PRIVILEGES ON TABLE products TO postgres;

GRANT ALL PRIVILEGES ON TABLE categories TO postgres;

GRANT ALL PRIVILEGES ON TABLE product_categories TO postgres;

-- SEED
INSERT INTO products (productid, name, imagepath, price)
    VALUES
        -- electronic
        ('92a7c388-6061-462c-a364-28516ff2ffa3', 'Electronic I', '/catalog/92a7c388-6061-462c-a364-28516ff2ffa3.jpeg', 13900), ('99c2f942-ab4e-4b95-af27-b4c79a4bc57b', 'Electronic II', '/catalog/99c2f942-ab4e-4b95-af27-b4c79a4bc57b.jpeg', 43385), ('dae3350c-3574-4abb-92da-f52355394de6', 'Electronic III', '/catalog/dae3350c-3574-4abb-92da-f52355394de6.jpeg', 85500),
        -- mechanic
        ('8a2c7532-e0ae-4312-be69-d2759afe88d1', 'Mechanic I', '/catalog/8a2c7532-e0ae-4312-be69-d2759afe88d1.jpeg', 10538), ('f60e4efe-78f2-4d10-be32-6702800aad56', 'Mechanic II', '/catalog/f60e4efe-78f2-4d10-be32-6702800aad56.jpeg', 50300), ('fa2a017d-ac24-40b4-9827-2f8ca3bf95b9', 'Mechanic III', '/catalog/fa2a017d-ac24-40b4-9827-2f8ca3bf95b9.jpeg', 90200),
        -- smart
        ('7dc448a5-6854-497a-9ebd-d302f2cc4526', 'Smart I', '/catalog/7dc448a5-6854-497a-9ebd-d302f2cc4526.jpeg', 10538), ('e5b98008-5e55-40ea-8f56-7d4041c71359', 'Smart II', '/catalog/e5b98008-5e55-40ea-8f56-7d4041c71359.jpeg', 50300), ('e60bfa8d-9854-4132-bb48-dc87632ac01d', 'Smart III', '/catalog/e60bfa8d-9854-4132-bb48-dc87632ac01d.jpeg', 90200),
        -- sport
        ('077c5f6b-9cec-4cf5-ab8d-101e831a7eeb', 'Sport I', '/catalog/077c5f6b-9cec-4cf5-ab8d-101e831a7eeb.jpeg', 10538), ('1641ffa1-cb5d-4757-8965-bc063d66e11a', 'Sport II', '/catalog/1641ffa1-cb5d-4757-8965-bc063d66e11a.jpeg', 50300), ('b13bb0b7-07db-4a38-9652-f98f08a8a4f3', 'Sport III', '/catalog/b13bb0b7-07db-4a38-9652-f98f08a8a4f3.jpeg', 90200);

INSERT INTO categories (categoryid, parentid, name, isfinal)
    VALUES (1, 0, 'analog', FALSE), (2, 0, 'digital', FALSE), (11, 1, 'mechanical', TRUE), (12, 1, 'electronic', TRUE), (21, 2, 'smart', TRUE), (22, 2, 'sport', TRUE);

INSERT INTO product_categories (productid, categoryid)
    VALUES
        -- electronic
        ('92a7c388-6061-462c-a364-28516ff2ffa3', 12), ('99c2f942-ab4e-4b95-af27-b4c79a4bc57b', 12), ('dae3350c-3574-4abb-92da-f52355394de6', 12),
        -- mechanical
        ('8a2c7532-e0ae-4312-be69-d2759afe88d1', 11), ('f60e4efe-78f2-4d10-be32-6702800aad56', 12), ('fa2a017d-ac24-40b4-9827-2f8ca3bf95b9', 12),
        -- smart
        ('7dc448a5-6854-497a-9ebd-d302f2cc4526', 21), ('e5b98008-5e55-40ea-8f56-7d4041c71359', 21), ('e60bfa8d-9854-4132-bb48-dc87632ac01d', 21),
        -- sport
        ('077c5f6b-9cec-4cf5-ab8d-101e831a7eeb', 22), ('1641ffa1-cb5d-4757-8965-bc063d66e11a', 22), ('b13bb0b7-07db-4a38-9652-f98f08a8a4f3', 22);


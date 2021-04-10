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
    VALUES ('9AAD6CF4-6EFB-4EC6-A4E0-64343BFE0134', 'Mechanical One', '/catalog/9AAD6CF4-6EFB-4EC6-A4E0-64343BFE0134.jpeg', 200), ('F068D900-C905-4E63-BE77-E796FEEBD648', 'Electronic One', '/catalog/F068D900-C905-4E63-BE77-E796FEEBD648.jpeg', 4000), ('81BA794D-390A-464B-B60F-68ADD6CD9687', 'Smart One', '/catalog/81BA794D-390A-464B-B60F-68ADD6CD9687.jpeg', 2050), ('39E211B6-FE78-4041-8D99-EB595233B49A', 'Sport One', '/catalog/39E211B6-FE78-4041-8D99-EB595233B49A.jpeg', 100);

INSERT INTO categories (categoryid, parentid, name, isfinal)
    VALUES (1, 0, 'Analog', FALSE), (2, 0, 'Digital', FALSE), (11, 1, 'Mechanical', TRUE), (12, 1, 'Electronic', TRUE), (21, 2, 'Smart', TRUE), (22, 2, 'Sport', TRUE);

INSERT INTO product_categories (productid, categoryid)
    VALUES ('9AAD6CF4-6EFB-4EC6-A4E0-64343BFE0134', 11), ('F068D900-C905-4E63-BE77-E796FEEBD648', 12), ('81BA794D-390A-464B-B60F-68ADD6CD9687', 21), ('39E211B6-FE78-4041-8D99-EB595233B49A', 22);


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
    VALUES ('9AAD6CF4-6EFB-4EC6-A4E0-64343BFE0134', 'Product 1', '/catalog/9AAD6CF4-6EFB-4EC6-A4E0-64343BFE0134.jpeg', 200), ('F068D900-C905-4E63-BE77-E796FEEBD648', 'Product 2', '/catalog/F068D900-C905-4E63-BE77-E796FEEBD648.jpeg', 4000), ('81BA794D-390A-464B-B60F-68ADD6CD9687', 'Product 3', '/catalog/81BA794D-390A-464B-B60F-68ADD6CD9687.jpeg', 2050), ('39E211B6-FE78-4041-8D99-EB595233B49A', 'Product 4', '/catalog/39E211B6-FE78-4041-8D99-EB595233B49A.jpeg', 100), ('6E8A34B6-C065-4187-96CA-C88D936CB01A', 'Product 5', '/catalog/6E8A34B6-C065-4187-96CA-C88D936CB01A.jpeg', 80000), ('0C68EFF0-70E4-4435-B79E-06DFA82F5325', 'Product 6', '/catalog/0C68EFF0-70E4-4435-B79E-06DFA82F5325.jpeg', 2001);

INSERT INTO categories (categoryid, parentid, name, isfinal)
    VALUES (1, 0, 'Category 1', TRUE), (2, 0, 'Category 2', FALSE), (3, 0, 'Category 3', TRUE), (4, 2, 'Category 2 Sub 1', TRUE);

INSERT INTO product_categories (productid, categoryid)
    VALUES ('9AAD6CF4-6EFB-4EC6-A4E0-64343BFE0134', 1), ('F068D900-C905-4E63-BE77-E796FEEBD648', 1), ('81BA794D-390A-464B-B60F-68ADD6CD9687', 2), ('39E211B6-FE78-4041-8D99-EB595233B49A', 2), ('6E8A34B6-C065-4187-96CA-C88D936CB01A', 3), ('0C68EFF0-70E4-4435-B79E-06DFA82F5325', 4);


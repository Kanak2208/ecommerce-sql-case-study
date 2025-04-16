/* ===========================================================
   schema.sql  –  MySQL 8.0
   Creates the e‑commerce tables used in this case study
   =========================================================== */


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name        VARCHAR(100),
    signup_date DATE,
    country     VARCHAR(50)
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    price        DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    order_amount DECIMAL(10,2),
    status       VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT,
    product_id    INT,
    quantity      INT,
    price         DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

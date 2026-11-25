SELECT current_database();
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(50),
    registration_date DATE
);
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    city VARCHAR(50)
);
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10,2) NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id)
);
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    order_status VARCHAR(30),
    total_amount NUMERIC(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    stock_quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    last_updated DATE
);
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

INSERT INTO customers
(customer_name, email, phone, city, registration_date)
VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Delhi', '2026-01-10'),
('Priya Verma', 'priya@gmail.com', '9876543211', 'Noida', '2026-01-15'),
('Amit Kumar', 'amit@gmail.com', '9876543212', 'Mumbai', '2026-02-01'),
('Neha Singh', 'neha@gmail.com', '9876543213', 'Pune', '2026-02-10'),
('Rohit Gupta', 'rohit@gmail.com', '9876543214', 'Delhi', '2026-02-15');

INSERT INTO suppliers
(supplier_name, contact_person, phone, email, city)
VALUES
('ABC Traders', 'Suresh Mehta', '9811111111', 'abc@gmail.com', 'Delhi'),
('XYZ Distributors', 'Anil Gupta', '9822222222', 'xyz@gmail.com', 'Mumbai'),
('Modern Suppliers', 'Karan Singh', '9833333333', 'modern@gmail.com', 'Noida');

INSERT INTO products
(product_name, category, price, supplier_id)
VALUES
('Laptop', 'Electronics', 55000, 1),
('Mobile Phone', 'Electronics', 20000, 2),
('Headphones', 'Accessories', 1500, 1),
('Office Chair', 'Furniture', 7000, 3),
('Keyboard', 'Accessories', 1200, 2);

INSERT INTO orders
(customer_id, order_date, order_status, total_amount)
VALUES
(1, '2026-03-01', 'Delivered', 55000),
(2, '2026-03-02', 'Delivered', 20000),
(3, '2026-03-03', 'Pending', 8500),
(4, '2026-03-04', 'Delivered', 1500),
(5, '2026-03-05', 'Pending', 8200);


INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 55000),
(2, 2, 1, 20000),
(3, 4, 1, 7000),
(3, 5, 1, 1200),
(4, 3, 1, 1500),
(5, 4, 1, 7000),
(5, 5, 1, 1200);

INSERT INTO inventory
(product_id, stock_quantity, reorder_level, last_updated)
VALUES
(1, 10, 3, '2026-03-10'),
(2, 15, 5, '2026-03-10'),
(3, 25, 8, '2026-03-10'),
(4, 12, 4, '2026-03-10'),
(5, 30, 10, '2026-03-10');

SELECT * FROM customers;
SELECT * FROM products;
SELECT product_name, category, price
FROM products
WHERE price > 5000;

SELECT product_name, category, price
FROM products
ORDER BY price DESC;

SELECT SUM(total_amount) AS total_sales
FROM orders;

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

SELECT
    customers.customer_name,
    orders.order_id,
    orders.order_date,
    orders.order_status,
    orders.total_amount
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id;

SELECT
    products.product_name,
    products.category,
    products.price,
    suppliers.supplier_name,
    suppliers.city
FROM products
JOIN suppliers
ON products.supplier_id = suppliers.supplier_id;

SELECT
    products.product_name,
    inventory.stock_quantity,
    inventory.reorder_level
FROM products
JOIN inventory
ON products.product_id = inventory.product_id
WHERE inventory.stock_quantity <= inventory.reorder_level;

UPDATE inventory
SET stock_quantity = 2,
    last_updated = '2026-03-15'
WHERE product_id = 1;

SELECT
    products.product_name,
    inventory.stock_quantity,
    inventory.reorder_level
FROM products
JOIN inventory
ON products.product_id = inventory.product_id
WHERE inventory.stock_quantity <= inventory.reorder_level;

SELECT
    products.product_name,
    SUM(order_items.quantity) AS total_quantity_sold
FROM products
JOIN order_items
ON products.product_id = order_items.product_id
GROUP BY products.product_name
ORDER BY total_quantity_sold DESC;

SELECT
    AVG(total_amount) AS average_order_value
FROM orders;

SELECT
    product_name,
    price
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);

SELECT
    products.product_name,
    SUM(order_items.quantity * order_items.unit_price) AS product_revenue
FROM products
JOIN order_items
ON products.product_id = order_items.product_id
GROUP BY products.product_name
ORDER BY product_revenue DESC;

SELECT order_status,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_order_value
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_status;

SELECT
    c.customer_name,
    o.order_id,
    o.total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount > 10000
ORDER BY o.total_amount DESC;

BEGIN;

UPDATE inventory
SET stock_quantity = 100
WHERE product_id = 1;

SELECT product_id, stock_quantity
FROM inventory
WHERE product_id = 1;

ROLLBACK;

SELECT product_id, stock_quantity
FROM inventory
WHERE product_id = 1;

BEGIN;

INSERT INTO customers
(customer_name, email, phone, city, registration_date)
VALUES
('Simran Kapoor', 'simran@example.com', '9876500010', 'Jaipur', '2026-03-20');

COMMIT;

SELECT customer_id, customer_name, city
FROM customers
WHERE email = 'simran@example.com';

SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
  AND tc.constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY tc.table_name, tc.constraint_type;

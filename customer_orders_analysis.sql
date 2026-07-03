-- ============================================================
-- Project: Customer Orders Analysis
-- Tool: MySQL
-- Description: Analysing customer orders, revenue trends,
--              and product performance using SQL.
-- ============================================================


-- ============================================================
-- SECTION 1: CREATE TABLES & INSERT DATA
-- ============================================================

CREATE DATABASE IF NOT EXISTS customer_orders_db;
USE customer_orders_db;

-- Customers Table
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city          VARCHAR(30),
    segment       VARCHAR(20)
);

INSERT INTO customers VALUES
(1,  'Amit Sharma',   'Delhi',     'Retail'),
(2,  'Priya Singh',   'Mumbai',    'Wholesale'),
(3,  'Rahul Verma',   'Bangalore', 'Retail'),
(4,  'Sneha Kapoor',  'Delhi',     'Wholesale'),
(5,  'Vikas Kumar',   'Hyderabad', 'Retail'),
(6,  'Pooja Sharma',  'Chennai',   'Wholesale'),
(7,  'Arjun Singh',   'Pune',      'Retail'),
(8,  'Neha Gupta',    'Noida',     'Retail'),
(9,  'Rohan Mehta',   'Kolkata',   'Wholesale'),
(10, 'Ritu Malhotra', 'Jaipur',    'Retail');

-- Products Table
CREATE TABLE products (
    product_id       INT PRIMARY KEY,
    product_name     VARCHAR(50),
    category         VARCHAR(30),
    unit_price       DECIMAL(10,2)
);

INSERT INTO products VALUES
(1, 'Laptop',       'Electronics',  45000.00),
(2, 'Desk Chair',   'Furniture',    8500.00),
(3, 'Headphones',   'Electronics',  2500.00),
(4, 'Notebook Set', 'Stationery',    350.00),
(5, 'Monitor',      'Electronics',  18000.00),
(6, 'Bookshelf',    'Furniture',    5500.00),
(7, 'Keyboard',     'Electronics',  1800.00),
(8, 'Pen Set',      'Stationery',    200.00);

-- Orders Table
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    product_id  INT,
    order_date  DATE,
    quantity    INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);

INSERT INTO orders VALUES
(101, 1,  1, '2024-01-05', 1),
(102, 2,  2, '2024-01-12', 3),
(103, 3,  3, '2024-01-20', 2),
(104, 4,  5, '2024-02-03', 1),
(105, 5,  4, '2024-02-10', 5),
(106, 6,  1, '2024-02-18', 2),
(107, 7,  6, '2024-03-01', 1),
(108, 8,  7, '2024-03-08', 3),
(109, 9,  2, '2024-03-15', 2),
(110, 10, 8, '2024-03-22', 10),
(111, 1,  5, '2024-04-02', 1),
(112, 2,  3, '2024-04-10', 4),
(113, 3,  1, '2024-04-18', 1),
(114, 4,  7, '2024-04-25', 2),
(115, 5,  6, '2024-05-05', 1),
(116, 6,  4, '2024-05-12', 8),
(117, 7,  5, '2024-05-20', 2),
(118, 8,  1, '2024-06-03', 1),
(119, 9,  3, '2024-06-10', 3),
(120, 10, 2, '2024-06-18', 2),
(121, 1,  7, '2024-07-01', 5),
(122, 2,  1, '2024-07-15', 1),
(123, 3,  8, '2024-07-22', 20),
(124, 4,  2, '2024-08-05', 2),
(125, 5,  5, '2024-08-18', 1);


-- ============================================================
-- SECTION 2: BASIC EXPLORATION
-- ============================================================

-- Q1: View all customers
SELECT * FROM customers;

-- Q2: View all products ordered by price descending
SELECT *
FROM products
ORDER BY unit_price DESC;

-- Q3: All orders placed in Q1 2024 (Jan - Mar)
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY order_date;

-- Q4: Orders with quantity greater than 3
SELECT *
FROM orders
WHERE quantity > 3
ORDER BY quantity DESC;


-- ============================================================
-- SECTION 3: JOINS
-- ============================================================

-- Q5: Full order details — customer name, product, category,
--     quantity, unit price, and total revenue per order
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    o.quantity,
    p.unit_price,
    (o.quantity * p.unit_price) AS total_revenue,
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
ORDER BY o.order_date;

-- Q6: Orders placed by Retail segment customers only
SELECT
    o.order_id,
    c.customer_name,
    c.segment,
    p.product_name,
    (o.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
WHERE c.segment = 'Retail'
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 4: AGGREGATIONS
-- ============================================================

-- Q7: Total revenue and total orders per customer
--     sorted by revenue descending
SELECT
    c.customer_name,
    c.city,
    COUNT(o.order_id)                        AS total_orders,
    SUM(o.quantity * p.unit_price)           AS total_revenue,
    ROUND(AVG(o.quantity * p.unit_price), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_revenue DESC;

-- Q8: Revenue by product category
SELECT
    p.category,
    COUNT(o.order_id)              AS total_orders,
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Q9: Monthly revenue trend
SELECT
    DATE_FORMAT(o.order_date, '%b %Y')     AS month,
    COUNT(o.order_id)                       AS total_orders,
    SUM(o.quantity * p.unit_price)          AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'),
         DATE_FORMAT(o.order_date, '%b %Y')
ORDER BY DATE_FORMAT(o.order_date, '%Y-%m');

-- Q10: Customers with more than 2 orders (HAVING clause)
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 2
ORDER BY total_orders DESC;

-- Q11: Revenue by customer segment
SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id)  AS total_customers,
    COUNT(o.order_id)              AS total_orders,
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
GROUP BY c.segment
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 5: SUBQUERIES
-- ============================================================

-- Q12: Product that generated the highest total revenue
SELECT
    product_name,
    category,
    total_revenue
FROM (
    SELECT
        p.product_name,
        p.category,
        SUM(o.quantity * p.unit_price) AS total_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.category
) AS product_revenue
ORDER BY total_revenue DESC
LIMIT 1;

-- Q13: Customers who spent above the average order value
SELECT
    c.customer_name,
    SUM(o.quantity * p.unit_price) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING total_spent > (
    SELECT AVG(quantity * unit_price)
    FROM orders
    JOIN products USING (product_id)
)
ORDER BY total_spent DESC;


-- ============================================================
-- SECTION 6: WINDOW FUNCTIONS
-- ============================================================

-- Q14: Rank customers by total revenue using RANK()
SELECT
    c.customer_name,
    c.city,
    SUM(o.quantity * p.unit_price)                        AS total_revenue,
    RANK() OVER (ORDER BY SUM(o.quantity * p.unit_price)
                 DESC)                                     AS revenue_rank
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY revenue_rank;

-- Q15: Running total of revenue ordered by date
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    (o.quantity * p.unit_price)                           AS order_revenue,
    SUM(o.quantity * p.unit_price) OVER (
        ORDER BY o.order_date
    )                                                      AS running_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
ORDER BY o.order_date;

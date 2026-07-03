# Customer Orders Analysis

Worked with a small relational database of customers, products, and orders to practice writing SQL queries that go beyond basic SELECT statements. The dataset has 3 tables and 25 orders spanning 8 months.

## Database Structure

| Table | Rows | Description |
|---|---|---|
| customers | 10 | Customer details — name, city, segment |
| products | 8 | Product catalogue with categories and unit prices |
| orders | 25 | Transactional order records with quantity and date |

## What the Queries Cover

**Basic Exploration** — Filtering orders by date range, sorting products by price, pulling orders above a quantity threshold.

**Joins** — Combined all three tables to get full order details including customer name, product, category, quantity, unit price, and revenue per order. Also filtered by customer segment using a JOIN + WHERE combination.

**Aggregations** — Revenue and order count per customer, revenue by product category, monthly revenue trend, customers with more than 2 orders using HAVING.

**Subqueries** — Identified the top revenue-generating product using a derived table. Found customers who spent above the average order value using a subquery inside HAVING.

**Window Functions** — Ranked customers by total revenue using RANK(). Built a running total of revenue ordered by date using SUM() OVER().

## Key Results

- Electronics was the highest revenue category by a significant margin
- Laptop was the top revenue-generating product
- Wholesale segment had higher average order values compared to Retail
- Revenue grew from Q1 through Q2 before stabilising in Q3

## Files

| File | Description |
|---|---|
| `customer_orders_analysis.sql` | All queries — table creation, data insertion, and analysis |

## How to Run

1. Open MySQL Workbench or any MySQL client
2. Run the full script — it creates the database, tables, inserts data, and runs all queries
3. Queries are organised in sections so you can run them independently

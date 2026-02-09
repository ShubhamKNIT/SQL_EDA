-- \d gold.fact_sales;

-- Find the Total Sales
SELECT 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT 
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT
    AVG(price) AS avg_price
FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT
    COUNT(order_number) AS total_orders
FROM gold.fact_sales;
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- \d gold.dim_products;

-- Find the Total number of Products
SELECT
    COUNT(product_name) AS total_products
FROM gold.dim_products;
SELECT
    COUNT(DISTINCT product_name) AS total_products
FROM gold.dim_products;

-- \d gold.dim_customers;

-- Find the Total number of Customers
SELECT
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;
SELECT
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;


-- Find the Total number of Customers that has placed an order
SELECT  
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales;


-- Generate a Report that shows all key metrics for the business

SELECT 
    'Total Sales' AS measure_name, 
    SUM(sales_amount) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 
    'Total Quantity' AS measure_name,
    SUM(quantity) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT
    'Average Price' AS measure_name,
    CAST(AVG(price) AS DECIMAL(10, 2)) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT
    'Total Nr. Orders' AS measure_name,
    COUNT(DISTINCT order_number) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT
    'Total Nr. Products' AS measure_name,
    COUNT(DISTINCT product_name) AS measure_value
FROM gold.dim_products
UNION ALL
SELECT
    'Total Nr. Customers' AS measure_name,
    COUNT(DISTINCT customer_key) AS measure_value
FROM gold.dim_customers;

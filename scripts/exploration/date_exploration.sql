-- Find first and last order dates

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    CAST(CAST(MAX(order_date) - MIN(order_date) AS DECIMAL(10, 2))/365 AS DECIMAL(10, 2)) AS order_range_years
FROM gold.fact_sales;

-- Find the youngest and oldest customer birthdate
SELECT
    MIN(birthdate) AS oldest_customer_birthdate,
    CAST(CAST(DATE(NOW()) - MIN(birthdate) AS DECIMAL(10, 2))/365 AS DECIMAL(10, 2)) AS oldest_customer_age,
    MAX(birthdate) AS youngest_customer_birthdate,
    CAST(CAST(DATE(NOW()) - MAX(birthdate) AS DECIMAL(10, 2))/365 AS DECIMAL(10, 2)) AS youngest_customer_age
FROM gold.dim_customers;
-- Change Over Time Analysis
-- ∑ [Measure] By [Date Dimension]


-- Total Sales By Year
SELECT
    EXTRACT(YEAR FROM order_date) as order_year,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);

-- Total sales by month
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS order_year_month,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY TO_CHAR(order_date, 'YYYY-MM');

-- Average Cost By Month
SELECT
    EXTRACT(MONTH FROM order_date) as order_month,
    AVG(price) AS avg_cost
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);
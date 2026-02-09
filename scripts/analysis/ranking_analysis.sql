-- What is Ranking Analysis?
-- Top/Bottom Performers Analysis
-- Rank[Dimension] BY ∑ [Measure]

-- Which 5 products generate the highest revenue?
SELECT
    dp.product_name AS product_name,
    SUM(fs.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_name
LIMIT 5;


-- What are the 5 worst-performing products in terms of sales?
SELECT
    dp.product_name AS product_name,
    SUM(fs.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount)) AS rank_products
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_name
LIMIT 5;

-- Find the top-10 customers who have generated the highest revenue
-- and 3 customers with the fewest orders placed
SELECT
    dp.product_name AS product_name,
    SUM(fs.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount)) AS rank_products
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_name
LIMIT 10;

SELECT
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY 
    dc.customer_key,
    dc.first_name,
    dc.last_name
ORDER BY total_orders
LIMIT 3;
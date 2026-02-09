-- Performance Analysis
-- Current[Measure] - Target[Measure]

-- Current Sales - Average Sales
-- Current Year Sales - Previous Year Sales
-- Current Sales - Lowest Sales

-- Analyze the yearly performance of products by comparing their sales
-- to both the average sales performance of the product and the previous
-- year's sales

WITH yearly_product_sales AS (
    SELECT
        TO_CHAR(fs.order_date, 'YYYY') AS order_year,
        dp.product_name AS product_name,
        SUM(fs.sales_amount) AS current_sales
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key
    WHERE fs.order_date IS NOT NULL
    GROUP BY 
        TO_CHAR(fs.order_date, 'YYYY'),
        dp.product_name
),
yearly_product_sales_t1 AS (
    SELECT
        order_year,
        product_name,
        current_sales,
        AVG(current_sales) OVER(
            PARTITION BY product_name
        ) AS avg_sales,
        LAG(current_sales, 1, 0) OVER(
            PARTITION BY product_name
        ) AS previous_sales,
        MIN(current_sales) OVER(
            PARTITION BY product_name
        ) AS min_sales
    FROM yearly_product_sales
    ORDER BY product_name, order_year
)
SELECT 
    order_year,
    product_name,
    current_sales,
    avg_sales,
    current_sales - avg_sales AS avg_diff,
    CASE
        WHEN current_sales - avg_sales < 0
            THEN 'Below Avg'
        WHEN current_sales - avg_sales > 0
            THEN 'Above Avg'
        ELSE 
            'Avg'
    END AS avg_change,
    previous_sales,
    current_sales - previous_sales AS sales_yoy,
    CASE
        WHEN current_sales - previous_sales < 0
            THEN 'Below'
        WHEN current_sales - previous_sales > 0
            THEN 'Above'
        ELSE 
            'Same'
    END AS sales_yoy_change,
    current_sales - min_sales AS sales_lb
FROM yearly_product_sales_t1;

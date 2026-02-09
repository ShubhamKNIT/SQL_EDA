-- Part-to-Whole Analysis
-- ([Measure] / Total [Measure]) * 100 By [Dimension]

-- (Sales / Total Sales) * 100 By Category
-- (Quantity / Total Quantity) * 100 By Country

-- Which categories contribute the most to overall sales?
WITH sales_by_category AS (
    SELECT
        dp.category AS category,
        SUM(fs.sales_amount) AS total_sales
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key
    GROUP BY dp.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(
        ROUND(
            CAST(
                total_sales 
                AS NUMERIC
            ) / SUM(total_sales) OVER()
            * 100,
            2
        ),
        ' %'
    ) AS sales_contribution
FROM sales_by_category;
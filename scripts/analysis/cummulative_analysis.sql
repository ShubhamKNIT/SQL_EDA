-- Cummulative Analysis
-- ∑ [Cummulative Measure] By [Date Dimension]

-- Running Total Sales By Year
-- Moving Average Price By Year

WITH yearly_sales AS (
    SELECT
        TO_CHAR(order_date, 'YYYY') AS order_year,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY TO_CHAR(order_date, 'YYYY')
)
SELECT
    order_year,
    total_sales,
    SUM(total_sales) OVER(
        ORDER BY order_year
    ) AS running_total_sales,
    AVG(avg_price) OVER(
        ORDER BY order_year
    ) AS moving_avg_price
FROM yearly_sales
ORDER BY order_year;

-- Running Total Sales By Year-Month
-- Moving Average Price By Year-Month

WITH monthly_sales AS (
    SELECT
        TO_CHAR(order_date, 'YYYY-MM') AS order_year_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT DISTINCT
    order_year_month,
    total_sales,
    SUM(total_sales) OVER(
        ORDER BY order_year_month
    ) AS running_monthly_sales,
    AVG(avg_price) OVER(
        ORDER BY order_year_month
    ) AS moving_avg_price
FROM monthly_sales
ORDER BY order_year_month;


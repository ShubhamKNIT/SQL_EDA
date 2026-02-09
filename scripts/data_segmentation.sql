-- Data Segmentation
-- [Measure] by [Measure]

-- Total Products by Sales Range
-- Total Customers by Age

/*
    Segment products into cost ranges and
    count how many products fall into each segment
*/

WITH segmented_products AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100
                THEN 'low'
            WHEN cost <= 500
                THEN 'medium'
            WHEN cost > 500
                THEN 'high'
            ELSE
                'n/a'
        END AS cost_range
    FROM gold.dim_products
)
SELECT
    cost_range,
    COUNT(product_name) AS products_cnt
FROM segmented_products
GROUP BY cost_range;

/*
    Group customers into three segments 
    based on their spending behaviour:

    - VIP: Customers with at least 12 months
        of history and spending > $5000.
    - Regular: Customers with at least 12 months
        of history but spending ≤ $5000.
    - New: Customers with lifespan less than
        12 months.
    
    And find the total number of customers by each group
*/

WITH customers_spending AS (
    SELECT
        dc.customer_key AS customer_key,
        SUM(fs.sales_amount) AS total_spending,
        -- MIN(fs.order_date) AS first_order,
        -- MAX(fs.order_date) AS last_order,
        EXTRACT(YEAR FROM AGE(MAX(fs.order_date), MIN(fs.order_date))) * 12 + 
        EXTRACT(MONTH FROM AGE(MAX(fs.order_date), MIN(fs.order_date))) +
        CASE
            WHEN EXTRACT(DAY FROM AGE(MAX(fs.order_date), MIN(fs.order_date))) >= 15
                THEN 1
            ELSE
                0
        END AS lifespan_months
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
    ON fs.customer_key = dc.customer_key
    GROUP BY dc.customer_key
    ORDER BY dc.customer_key
),
segmented_customers AS (
    SELECT
        customer_key,
        total_spending,
        CASE
            WHEN lifespan_months >= 12
                THEN 
                    CASE
                        WHEN total_spending > 5000
                            THEN 'VIP'
                        ELSE
                            'Regular'
                    END
            ELSE
                'New'
        END AS customer_category
    FROM customers_spending
) 
SELECT 
    customer_category,
    COUNT(customer_key) AS customers_cnt
FROM segmented_customers
GROUP BY customer_category;
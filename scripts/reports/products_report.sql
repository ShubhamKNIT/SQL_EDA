/*
===================================================================================
Product Report
===================================================================================

Purpose:
    - This report consolidates key product metrics and behaviours.

Highlights:
    1. Gathers essential fields such as product names, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculate valuable KPIs:
        - recency (months since last order)
        - average order value (AOR)
        - average monthly revenue
*/

CREATE VIEW gold.report_products AS (
    WITH products_sales_info AS (
        SELECT
            fs.order_number,
            fs.customer_key,
            fs.order_date,
            fs.sales_amount,
            fs.quantity,
            dp.product_key,
            dp.product_id,
            dp.product_name,
            dp.category,
            dp.subcategory,
            dp.cost
        FROM gold.fact_sales AS fs
        LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
        WHERE fs.order_date IS NOT NULL
    ),
    products_aggregated AS (
        SELECT
            product_name,
            category,
            subcategory,
            cost,
            COUNT(DISTINCT order_number) AS total_orders,
            SUM(sales_amount) AS total_sales,
            SUM(quantity) AS total_quantity,
            COUNT(DISTINCT customer_key) AS total_customers,
            EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
            EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) +
            CASE
                WHEN EXTRACT(DAY FROM AGE(MAX(order_date), MIN(order_date))) >= 15
                    THEN 1
                ELSE 
                    0
            END AS order_lifespan_months,
            MAX(order_date) AS last_order_date
        FROM products_sales_info
        GROUP BY 
            product_name,
            category,
            subcategory,
            cost
    )
    SELECT 
        product_name,
        category,
        subcategory,
        cost,
        total_orders,
        total_sales,
        CASE
            WHEN total_sales > 50000
                THEN 'High-Performer'
            WHEN total_sales >= 10000
                THEN 'Mid-Performer'
            ELSE 
                'Low-Performer'
        END AS product_segment,
        total_quantity,
        total_customers
        order_lifespan_months,
        last_order_date,
        CASE
            WHEN total_quantity > 0
                THEN ROUND(CAST(total_sales AS NUMERIC) / total_quantity, 2)
            ELSE
                total_sales
        END AS average_order_value,
        CASE
            WHEN order_lifespan_months > 0
                THEN ROUND(CAST(total_sales AS NUMERIC) / order_lifespan_months, 2)
            ELSE
                total_sales
        END AS average_monthly_revenue
    FROM products_aggregated
);
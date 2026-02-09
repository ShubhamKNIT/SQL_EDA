/*
===================================================================================
Customer Report
===================================================================================

Purpose:
    - This report consolidates key customer metrics and behaviours.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into field categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculate valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
*/

CREATE VIEW gold.report_customers AS (
    WITH customers_sales_info AS (
        SELECT
            fs.order_number,
            fs.product_key,
            fs.order_date,
            fs.sales_amount,
            fs.quantity,
            dc.customer_key,
            dc.customer_number,
            CONCAT(dc.first_name, ' ' , dc.last_name) AS customer_name,
            dc.birthdate,
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, dc.birthdate)) AS age
        FROM gold.fact_sales AS fs
        LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
        WHERE fs.order_date IS NOT NULL
    ),
    customers_aggregated AS (
        SELECT
            customer_key,
            customer_number,
            customer_name,
            age,
            COUNT(DISTINCT order_number) AS total_orders,
            SUM(sales_amount) AS total_sales,
            SUM(quantity) AS total_quantity,
            COUNT(DISTINCT product_key) AS total_products,
            EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
            EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) + 
            CASE
                WHEN EXTRACT(DAY FROM AGE(MAX(order_date), MIN(order_date))) >= 15
                    THEN 1 
                ELSE 0
            END AS order_lifespan_months,
            MAX(order_date) AS last_order_date
        FROM customers_sales_info
        GROUP BY 
            customer_key, 
            customer_number, 
            customer_name, 
            age
    )
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        CASE
            WHEN age < 20 
                THEN 'Under 20'
            WHEN age < 30
                THEN 'Between 20 and 30'
            WHEN age < 40
                THEN 'Between 30 and 39'
            WHEN age < 50
                THEN 'Between 40 and 49'
            ELSE
                '50 and above'
        END AS age_group,
        CASE
            WHEN order_lifespan_months >= 12
                THEN 
                    CASE
                        WHEN total_sales > 5000
                            THEN 'VIP'
                        ELSE
                            'Regular'
                    END
            ELSE
                'New'
        END AS customer_segment,
        total_orders,
        total_sales,
        total_quantity,
        total_products,
        order_lifespan_months,
        last_order_date,
        CASE
            WHEN total_quantity > 0
                THEN ROUND(CAST(total_sales AS NUMERIC) / total_quantity, 2)
            ELSE
                total_sales
        END AS avg_order_value,
        CASE 
            WHEN order_lifespan_months > 0
                THEN ROUND(CAST(total_sales AS NUMERIC) / order_lifespan_months, 2)
            ELSE 
                total_sales
        END AS avg_monthly_spend
    FROM customers_aggregated
);
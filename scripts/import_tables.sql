-- ===================================================================
-- TABLE: gold.dim_customers
-- ===================================================================

-- customer_key,customer_id,customer_number,first_name,last_name,country,marital_status,gender,birthdate,create_date
-- 1,11000,AW00011000,Jon,Yang,Australia,Married,Male,1971-10-06,2025-10-06

CREATE TABLE IF NOT EXISTS gold.dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

TRUNCATE TABLE gold.dim_customers;
\copy gold.dim_customers
FROM '/tmp/datasets/flat-files/dim_customers.csv'
DELIMITER ','
CSV HEADER;

-- ===================================================================
-- TABLE: gold.dim_products
-- ===================================================================

-- product_key,product_id,product_number,product_name,category_id,category,subcategory,maintenance,cost,product_line,start_date
-- 1,210,FR-R92B-58,HL Road Frame - Black- 58,CO_RF,Components,Road Frames,Yes,0,Road,2003-07-01

CREATE TABLE IF NOT EXISTS gold.dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

TRUNCATE TABLE gold.dim_products;
\copy gold.dim_products 
FROM '/tmp/datasets/flat-files/dim_products.csv'
DELIMITER ','
HEADER CSV;

-- ===================================================================
-- TABLE: gold.fact_sales
-- ===================================================================

-- order_number,product_key,customer_key,order_date,shipping_date,due_date,sales_amount,quantity,price
-- SO54496,282,5400,2013-03-16,2013-03-23,2013-03-28,25,1,25

CREATE TABLE IF NOT EXISTS gold.fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity INT,
    price INT 
);

TRUNCATE TABLE gold.fact_sales;
\copy gold.fact_sales
FROM '/tmp/datasets/flat-files/fact_sales.csv'
DELIMITER ','
HEADER CSV;
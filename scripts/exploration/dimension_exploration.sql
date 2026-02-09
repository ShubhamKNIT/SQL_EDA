-- Explore All countries' customers are from ...

SELECT DISTINCT country
FROM gold.dim_customers;

-- Explore All Categories, SubCategories
SELECT DISTINCT 
    category,
    subcategory
FROM gold.dim_products
ORDER BY 1, 2;

SELECT DISTINCT 
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY 1, 2;
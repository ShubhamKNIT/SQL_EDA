-- Explore All Objects in the Database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- OR

\d *.*;

-- Explore All columns in the Database
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'dim_customers';

-- OR

\d gold.dim_customers;
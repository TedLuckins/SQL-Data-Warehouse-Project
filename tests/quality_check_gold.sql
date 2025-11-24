/*
=============================================================================
Quality Checks
=============================================================================
Script Prupose:
	This script executes quality checks for gold layer views to validate 
	their accuracy and consistency.

Usage Notes:
	- Run these checks after loading silver layer tables.
	- Investigste and resolve discepensies found during the checks.
=============================================================================
*/
--------------------------------------
-- Check For: gold.dim_customers
--------------------------------------
-- Check for duplicate product keys
-- Expectation: No Results
SELECT 
	cusomter_key, 
	COUNT(*) AS duplicate_count
FROM (SELECT * FROM  gold.dim_customers)t 
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Data Standardisation
-- Expectation: 'n/a', 'Female', 'Male'
SELECT DISTINCT
	gender
FROM gold.dim_customers;


--------------------------------------
-- Check For: gold.dim_products
--------------------------------------
-- Check for duplicate product keys
-- Expectation: No Results
SELECT 
	product_key, 
	COUNT(*) 
FROM (SELECT * FROM  gold.dim_products)t 
GROUP BY product_key
HAVING COUNT(*) > 1;


--------------------------------------
-- Check For: gold.fact_sales
--------------------------------------
-- Foreign Key Integrity (Dimensions)
--Check the model connectivity between facts and dimensons
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		  p.product_key = f.product_key  
WHERE p.product_key IS NULL;

-- ====================================================================================
-- Quality Checks
-- ====================================================================================
-- Script purpose:
--   This script contains data quality checks to ensure silver tables hold valid data
--   each query details its purpose and expected result
-- ====================================================================================
--------------------------------------
-- Check For: silver.crm_cust_info
--------------------------------------
-- Check For Nulls or Duplicates in primary key
-- Expectation: No Result
SELECT
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Standardisation & Consistency
-- Expectation: 'n/a', 'Male', 'Female'
SELECT DISTINCT 
	cst_gndr
FROM silver.crm_cust_info;

-- Expectation: 'Single', 'Married'
SELECT DISTINCT 
	cst_material_status
FROM silver.crm_cust_info;

--------------------------------------
-- Check For: silver.crm_prd_info
--------------------------------------
-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT
	prd_id,
	Count(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for NULLs or Negative Numbers
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardisation & Consistency
-- Expectation: 'Mountain', 'n/a', 'Other Sales', 'Road', 'Touring'
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
-- Expectation: No Result
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--------------------------------------
-- Check For: silver.crm_sales_details
--------------------------------------
-- Check For Invalid Dates
SELECT
	NULLIF (sls_order_dt, 0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_ship_dt > sls_due_dt

-- Check Data Consistency: Between Sales, Quantity, Price
-- >> Sales = Quantity * Price
-- >> Values Must not be NULL, Zero, or Negative
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

--------------------------------------
-- Check For: silver.erp.cust_az12
--------------------------------------
-- Ensure matching cid with customer key
SELECT
	cid,
	bdate,
	gen
FROM silver.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)


-- Check for invalid Birthdays
-- Expectation: bdate < '1924-01-01'
SELECT DISTINCT	
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardisation
-- Expectation: 'n/a', 'Female', 'Male'
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12

--------------------------------------
-- Check For: silver.erp.loc_a101
--------------------------------------
-- Check cid is mathcing to customer key
-- Expectation: No Result
SELECT 
	cid
FROM silver.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- Data Standardisation & Consistency
-- Expectation: Country Full Name or 'n/a'
SELECT DISTINCT 
	cntry
FROM silver.erp_loc_a101
ORDER BY cntry

--------------------------------------
-- Check For: silver.erp.px_cat_g1v2
--------------------------------------
-- Check for unwanted Spaces
-- Expectation
SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat!= TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardisation & Consistency
SELECT DISTINCT
	cat
FROM silver.erp_px_cat_g1v2

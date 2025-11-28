-- Find the total Sales
SELECT
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT 
	SUM(quantity) AS total_quantity 
FROM gold.fact_sales;
 
 -- OR 

SELECT
	COUNT(DISTINCT product_key) AS items_sold
FROM gold.fact_sales
	
-- Find the average selling price
SELECT
	AVG(price) AS average_price
FROM gold.fact_sales;

-- Find the total number of Orders
SELECT
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- Find the total number of products
SELECT 
	COUNT(DISTINCT product_id) AS total_products
FROM gold.dim_products;

-- Find the total number customers
SELECT
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT
	COUNT(DISTINCT customer_key) AS customers_that_ordered
FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL 
SELECT 'Total No. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL 
SELECT 'Total No. Products', COUNT( product_name) FROM gold.dim_products
UNION ALL 
SELECT'Total No. Customers', COUNT(customer_key) FROM gold.dim_customers 



/*
==================================================================================
Product Report
==================================================================================
Purpose:
	- This report consolidates key product metrics and behaviours

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
==================================================================================
*/
/*
----------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
----------------------------------------------------------------------------------
*/
CREATE OR ALTER VIEW gold.report_products AS
WITH base_query AS (
SELECT
	fs.order_number,
	fs.customer_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dp.product_key,
	dp.product_name,
	dp.category,
	dp.subcategory,
	dp.cost
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
WHERE order_date IS NOT NULL
)
/*
----------------------------------------------------------------------------------
2) Customer Aggregation: Summarises key metrics at the product level
----------------------------------------------------------------------------------
*/
, product_aggregation AS (
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order,
	DATEDIFF(month, last_order, GETDATE()) AS recency,
	-- Product performance segmants
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales  >= 10000  THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_performance,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	-- Compute average order Revenue (AOR)
	CASE WHEN total_orders = 0 THEN 0
		ELSE  total_sales / total_orders
	END AS avg_order_rev,
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_rev
FROM product_aggregation
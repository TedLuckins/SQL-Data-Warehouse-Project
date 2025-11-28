-- Segment products into cost ranges and count
-- how many products fall into each segment
WITH product_segments as (
SELECT 
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '500-1000'
		ELSE 'Above 1000'
	END cost_range
FROM gold.dim_products
)

SELECT
	cost_range,
	COUNT(product_key) as total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


-- Gtoup customers into three segments based on their spending behaviour:
-- VIP: at least 12 months of history and spending more than £5000
-- Regular: at least 12 months of history but spending £5000 or less
-- NEW: Lifespan less than 12 months
-- AND find the total number of customer by each group

WITH customer_spending AS (
SELECT
	dc.customer_key,
	SUM(fs.sales_amount) AS total_spending,
	MIN(fs.order_date) AS first_order,
	MAX(fs.order_date) AS last_order,
	DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key
)


SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT
		customer_key,
		CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
		END customer_segment
	FROM customer_spending)t
GROUP BY customer_segment
ORDER BY total_customers DESC;

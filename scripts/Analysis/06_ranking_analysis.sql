-- Which 5 profucts generate the highest revenue?

SELECT TOP 5
	dp.product_name,
	SUM(fs.sales_amount) total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue DESC;

-------
-- OR
-------

SELECT *
FROM (
	SELECT
		dp.product_name,
		SUM(fs.sales_amount) total_revenue,
		RANK() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
	GROUP BY dp.product_name)t
WHERE rank_products <= 5;


-- What are the 5 worst performing products in terms of sales?

SELECT TOP 5
	dp.product_name,
	SUM(fs.sales_amount) total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue;


-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY 
	dc.customer_key,
	dc.first_name,
	dc.last_name
ORDER BY total_revenue DESC;


-- The 3 customers with the fewest orders placed
SELECT TOP 3
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY 
	dc.customer_key,
	dc.first_name,
	dc.last_name
ORDER BY total_orders;

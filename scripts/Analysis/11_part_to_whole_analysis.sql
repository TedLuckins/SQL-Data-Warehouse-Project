-- Which categories vontribute the most to overall sales?

WITH category_sales AS (
SELECT
	category,
	SUM(sales_amount) total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY category
)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER())*100, 2), '%') AS percentage_of_total
FROM category_sales


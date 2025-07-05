---=========================================================---
--------------------RANKING ANALYSIS--------------------------
     --------Order the values of Measure by Dimension----
	 -------- TOP N and BOTTOM N Performers--------
---=========================================================---
--Which 5 products generates the highest revenue
SELECT TOP 5 
	pd.product_name,
	SUM(sf.sales_amount) total_revenue
FROM gold.fact_sales sf
LEFT JOIN gold.dim_products pd
ON pd.product_key = sf.product_key
GROUP BY pd.product_name
ORDER BY total_revenue DESC

--What are the worst 5 performing products in terms of sales
SELECT  * FROM (
	SELECT 
		pd.product_name,
		SUM(sf.sales_amount) total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sf.sales_amount) ) product_rank 
	FROM gold.fact_sales sf
	LEFT JOIN gold.dim_products pd
	ON pd.product_key = sf.product_key
	GROUP BY pd.product_name
)T
WHERE product_rank <= 5

--Find the TOP-10 customers who have generated the highest revenue and 3 customers with fewest orders placed
SELECT TOP 10
	sf.customer_key,
	SUM(sf.sales_amount) Total_revenue,
	ROW_NUMBER() OVER( ORDER BY SUM(sf.sales_amount) DESC) cust_rank 
FROM gold.fact_sales sf
GROUP BY sf.customer_key

---------------------------------OR--------------------------------
SELECT TOP 10 
	cd.customer_key,
	cd.firstname,
	cd.lastname,
	SUM(sf.sales_amount) total_revenue
FROM gold.fact_sales sf
LEFT JOIN gold.dim_customers cd
ON cd.customer_key = sf.customer_key
GROUP BY cd.customer_key,
	     cd.firstname,
	     cd.lastname
ORDER BY total_revenue DESC


-- The 3 customers with fewest orders placed
SELECT TOP 3 
	cd.customer_key,
	cd.firstname,
	cd.lastname,
	COUNT(DISTINCT order_number) total_revenue
FROM gold.fact_sales sf
LEFT JOIN gold.dim_customers cd
ON cd.customer_key = sf.customer_key
GROUP BY cd.customer_key,
	     cd.firstname,
	     cd.lastname
ORDER BY total_revenue 

------------------------

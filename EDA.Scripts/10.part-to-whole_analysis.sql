---===================================================---
-----------------PART TO WHOLE (PROPOTIONAL ANALYSIS) ---------------
---Analyse how an individual part is performing compared to the overall, allowing us to understand which category has highest impact on business-----
---Analysed through measure/total measure * 100 by dimension---
---===================================================---

--Which categories contribute the most to over all sales?
WITH category_sales AS (
	SELECT
			p.category,
			SUM(f.sales_amount) total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products P
	ON f.product_key = p.product_key
	GROUP BY p.category 
)
SELECT  
	category,
	total_sales,
	SUM(total_sales) OVER() overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER()) *100,2),'%') sales_percentage
FROM category_sales	
ORDER BY total_sales DESC

---===================================================---
-----------------PERFORMANCE ANALYSIS---------------
---Compares the current value to the target value and helps measure success and compare performance---
---Analysed through current measure by target measure---
---===================================================---

--Analyse the yearly performance of the products by comparing the each product sales to 
   --both its average sales performance and previous year performance

WITH yearly_product_sales AS (	
	
	SELECT
		YEAR(f.order_date) sales_year,
		p.product_name,
		SUM(f.sales_amount) current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products P
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY 
	    YEAR(f.order_date), 
	    p.product_name
)

SELECT  
	sales_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) avg_diff,
	CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above_avg'
		 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) <0 THEN 'below_avg'
		 ELSE 'avg'
	END current_and_avg_sales_diff,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY sales_year) previous_year_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY sales_year)  sales_diff,
	CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY sales_year) > 0 THEN 'increase'
		 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY sales_year) < 0 THEN 'decrease'
		 ELSE 'no change'
	END current_and_previous_year_sales
FROM yearly_product_sales
ORDER BY product_name,sales_year

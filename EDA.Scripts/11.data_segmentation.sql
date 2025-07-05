---===================================================---
-----------------DATA SEGMENTATION ---------------
------Group the data based on the specific range, and it helps in understanding the correaltion between the two measures-----
------Analysed through measure by measure---
---===================================================---

/* Segment products into cost ranges
   and count how many products fall into each segment*/
WITH product_segmentation AS (
SELECT  
	product_name,
	product_cost,
	MAX(product_cost) OVER() max_cost,
	MIN(product_cost) OVER() min_cost,
	CASE WHEN product_cost > 1000 THEN 'above 1000'
		 WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'below 500'
	END product_segment
FROM gold.dim_products
)

SELECT 
	product_segment,
	COUNT(product_name) product_count
	FROM product_segmentation
	GROUP BY product_segment
	ORDER BY product_count DESC

	/* Group customers into 3 segments based on their spending behaviour:-
	   -VIP :- Customer with atleast 12 months of history and spends more then 5000/-rs
	   -Regular :- Customers with atleast 12 months of history and spends less then 5000/-rs
	   -New :- Customers with lifespan is less then 12 months
	find the total number of customers by each group */
	WITH cusomer_spending AS (
	SELECT 
		c.customer_key,
		SUM(f.sales_amount) total_sales,
		MIN(f.order_date) first_order,
		MAX(f.order_date) last_order,
		DATEDIFF(month,MIN(f.order_date),MAX(f.order_date)) life_span
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f
ON c.customer_key = f.customer_key
GROUP BY c.customer_key
)

SELECT  
	customer_segment,
	COUNT(customer_key) customers_coun
	FROM (
		SELECT  
		customer_key,
		total_sales,
		life_span,
		CASE WHEN life_span >= 12 AND total_sales > 5000 then 'VIP'
			 WHEN life_span >= 12 AND total_sales < 5000 then 'Regular'
			 WHEN life_span < 12 THEN 'NEW'
		END customer_segment
FROM cusomer_spending
)T
GROUP BY customer_segment
ORDER BY COUNT(customer_key) DESC


/*
---========================================================---
             ----------CUSTOMER REPORT---------
---========================================================---
==========================================================================================
 Purpose:-
            -- This report consolidates the key metrics and behaviour of the customers
Highlights :-

    1. Gathers essential information like Name, Age and Transactional details.
	2. Segments Customers into categories(VIP, Regular and New) and Age groups.
	
	3. Aggregates customer level metrics:-
       
	   - Total Orders
	   - Total Sales
	   - Total Quantity purchased
	   - Total_customers
	   - Total Products
	   - Lifespan(in months)

	4. Calaculates valuable KPI's:-

	   - recency(months since last order)
	   - Average order value
	   - Average monthly spend
==========================================================================================
*/

CREATE VIEW  gold.report_customers AS   
   
  --This view helps us analyze data easily by providing direct access and enabling query reuse.

WITH base_query AS (
     
	 /* ------------------------------------------------------------------------------------------
          1.BASE QUERY :- Retrieves core columns from the table
      --------------------------------------------------------------------------------------------*/
	SELECT 
		c.customer_key,
		c.customer_number,
		CONCAT(c.firstname, ' ' ,c.lastname) customer_name,
		c.gender,
		c.birthdate,
		DATEDIFF(year,c.birthdate,GETDATE()) age,
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		s.price
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = s.customer_key
	WHERE order_date IS NOT NULL
)

, customer_aggregations AS (

     /* ------------------------------------------------------------------------------------------
           2.Customer Aggregations:- Summerize key metrics at customer level
      --------------------------------------------------------------------------------------------*/

		SELECT 
			customer_key,
			customer_number,
			customer_name,
			age,
			COUNT(DISTINCT(order_number)) total_orders,
			SUM(sales_amount) total_sales,
			SUM(quantity) total_quantity,
			COUNT(product_key) total_products,
			MAX(order_date) last_order_date,
			DATEDIFF(month,MIN(order_date),MAX(order_date)) life_span
		FROM base_query
		GROUP BY customer_key,
				 customer_number,
				 customer_name,
				 age 
  )

/* ------------------------------------------------------------------------------------------
   3.KPI's(Key Performnce Indicators) Of Customers
--------------------------------------------------------------------------------------------*/
SELECT  
	customer_key, 
	customer_number,
	customer_name,
	age,

	---Segmented based on customer_age
	CASE WHEN age BETWEEN 30 AND 50 THEN '30-50'
	     WHEN age BETWEEN 50 AND 80 THEN '50-80'WHEN age BETWEEN 39 AND 50 THEN '39-50'
	     WHEN age >80 THEN 'above 80'
	END age_segment,

	---Segmented based on the lifespan and total_sales
	CASE WHEN life_span >= 12 AND total_sales > 5000 then 'VIP'
	     WHEN life_span >= 12 AND total_sales < 5000 then 'Regular'
	     WHEN life_span < 12 THEN 'NEW'
	END customer_segment,

	total_orders,
	total_sales,
	total_quantity,
	total_products,
	life_span,
	
	---Racency of the customer
	DATEDIFF(month,last_order_date,GETDATE()) racency,

	---AVO(Average Order Value)
	CASE WHEN total_orders = 0 THEN 0
	     ELSE total_sales/total_orders 
	END avg_order_value,

	---Average Monthly Value(AMV)
	CASE WHEN life_span = 0 THEN total_sales
	     ELSE total_sales/life_span
	END avg_monthly_value

FROM customer_aggregations

/* Successful view check--------

    SELECT * FROM gold.report_customers

 ----------------------------*/


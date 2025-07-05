/*
---========================================================---
             ----------PRODUCT REPORT---------
---========================================================---
==========================================================================================
 Purpose:-
            -- This report consolidates the key metrics and behaviour of the Products.
Highlights :-

    1. Gathers essential information like product_name, category, subcategory and cost.
	2. Segments products by revenue to identify high performers, mid-range or low performers.
	
	3. Aggregates product level metrics:-
       
	   - Total Orders
	   - Total Sales
	   - Total Quantity purchased
	   - Total customers(unique)
	   - Lifespan(in months)

	4. Calaculates valuable KPI's:-

	   - recency(months since last sale)
	   - Average order revenue(AOR)
	   - Average monthly revenue
==========================================================================================
*/


CREATE VIEW gold.report_products AS 

       --This view helps us analyze data easily by providing direct access and enabling query reuse.

WITH base_query AS (

      /* ------------------------------------------------------------------------------------------
              1.BASE QUERY :- Retrieves core columns from the table
        --------------------------------------------------------------------------------------------*/
	SELECT  
		f.customer_key,
		f.order_number,
		f.order_date,
		f.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.product_cost,
		f.sales_amount,
		f.quantity,
		f.price
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
)

,product_aggregations AS (

	/* ------------------------------------------------------------------------------------------
		 2.Product Aggregations:- Summerize key metrics at product level
	--------------------------------------------------------------------------------------------*/
	SELECT 
		product_key,
		product_name,
		category,
		subcategory,
		product_cost,
		COUNT(DISTINCT(customer_key)) total_customers,
		COUNT(DISTINCT(order_number)) total_orders,
		MAX(order_date) last_order_date,
		DATEDIFF(month,MIN(order_date),MAX(order_date)) life_span,
		SUM(sales_amount) total_sales,
		SUM(quantity) total_quantity,

		---Average selling price
		ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),1) average_selling_price
	FROM base_query
	GROUP BY product_key,
			 product_name,
			 category,
			 subcategory,
			 product_cost
)

/* ------------------------------------------------------------------------------------------
   3.Final Query :- Combining all the metrics into one.
--------------------------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	total_customers,
	total_orders,
	last_order_date,
	life_span,
	total_sales,
	total_quantity,
	average_selling_price,

	---Segmented based on the revenue
	CASE WHEN total_sales > 100000 THEN 'High-performers'
		 WHEN total_sales BETWEEN  50000 AND 100000 THEN 'Mid-range'
		 ELSE 'Low-performers'
	END sales_segment,

	---reacency of customers in months
	DATEDIFF(MONTH,last_order_date,GETDATE()) racency_in_months,

	---AOR(average order revenue)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales/total_orders 
	END avg_order_revenue,

	--AMR(average monthly revenue)
	CASE WHEN life_span = 0 THEN total_sales
		  ELSE total_sales/life_span
	END avg_monthly_revenue

FROM product_aggregations

/* Successful view check--------

    SELECT * FROM gold.report_products

 -----------------------

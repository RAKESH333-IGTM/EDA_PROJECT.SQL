---===================================================---
-----------------CHANGE-OVER-TIME ANALYSIS---------------
---Analyses how a measure evolves over time and helps track trends and identify seasonality in data---
---Analysed through measure by date_dimension---
---===================================================---


-----------------------------------------------------
---------Analyse sales performance over time------
-----------------------------------------------------
SELECT 
    	DATETRUNC(year,order_date) sales_year,            ---month wise sales analysis with date data_type
	--month(order_date)                               ---Year wise sales analysis with int data_type
	SUM(sales_amount) Total_sales,
	SUM(quantity) Total_quantity,  
	COUNT(customer_key) customer_count
FROM gold.fact_sales
GROUP BY DATETRUNC(year,order_date) 
HAVING  DATETRUNC(year,order_date) IS NOT NULL

---===================================================---
-----------------CUMULATIVE ANALYSIS---------------
---Aggregate the data progressively overtime and this helps to understand weather the business is growing or declining---
---Analysed through cumulative_measure by date_dimension---
---===================================================---

--Calculate the total sales per month and the running total of sales over time

SELECT  
	sales_month,
	Total_sales,
	SUM(Total_sales) OVER(ORDER BY sales_month)  running_total_over_month , --it has default window frame:- unbounded preceding and the current row
	AVG(Total_sales) OVER(ORDER BY sales_month)   avg_running_sales
FROM (
	SELECT  
		DATETRUNC(month,order_date) sales_month,
		SUM(sales_amount) Total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month,order_date)
)t

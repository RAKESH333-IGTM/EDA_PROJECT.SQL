---=========================================================---
--------------------DATE EXPLORATION---------------------------
-----------Understand the scope of data and timespan-----------
-----Formula used :- MAX(),MIN(),DATEDIFF(),YEAR(),MONTH()---
---=========================================================---

------------------------------------------------------
--find the date of the first order and the last order
------------------------------------------------------

SELECT 

	MIN(order_date) first_order,
	MAX(order_date) last_order,
	DATEDIFF(year, MIN(order_date),MAX(order_date)) year_difference,
	DATEDIFF(month, MIN(order_date),MAX(order_date)) month_difference,
	DATEDIFF(day, MIN(order_date),MAX(order_date)) day_difference

FROM gold.fact_sales

-----------------------------------------------------
--Find the youngest and the oldest  age customers
-----------------------------------------------------
SELECT 
	MIN(customer_age) lowest_age,
	MAX(customer_age) highest_age
FROM (
	SELECT 
		firstname,
		birthdate,
		DATEDIFF(year,birthdate,GETDATE()) customer_age
	FROM gold.dim_customers
)t

------------OR---------------
SELECT  
	MIN(birthdate) lowest_age,
	DATEDIFF(year,MIN(birthdate),GETDATE()),
	MAX(birthdate) Highest_age,
	DATEDIFF(year,MAX(birthdate),GETDATE())
FROM gold.dim_customers

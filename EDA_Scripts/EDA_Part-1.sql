
---=========================================================---
---------------DATA BASE EXPLORATION---------------------------
---=========================================================---

--- EXPLORING ALL OBJECTS IN THE DATA_BASE

SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'VIEW'
--WHERE TABLE_SCHEMA = 'gold'

---EXPLORING ALL COLUMNS OF THE OBJECTS

SELECT  *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'

--HOW MANY COLUMNS PRESENT IN EACH GOLD TABLE

SELECT  
	TABLE_NAME,
	COUNT(*) columns_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
GROUP BY TABLE_NAME

---=========================================================---
---------------DIMENSION EXPLORATION---------------------------
---Identifying Unique values in each dimension of the data---
---=========================================================---

--Explore all countries our customers come from

SELECT 
  DISTINCT country 
FROM gold.dim_customers

--Explore all categories 'The major divisions'

SELECT 
DISTINCT category,subcategory,product_name
FROM gold.dim_products
ORDER BY 1,2,3

---=========================================================---
--------------------DATE EXPLORATION---------------------------
-----------Understand the scope of data and timespan-----------
---=========================================================---

--find the date of the first order and the last order

SELECT 

	MIN(order_date) first_order,
	MAX(order_date) last_order,
	DATEDIFF(year, MIN(order_date),MAX(order_date)) year_difference,
	DATEDIFF(month, MIN(order_date),MAX(order_date)) month_difference,
	DATEDIFF(day, MIN(order_date),MAX(order_date)) day_difference

FROM gold.fact_sales

--Find the youngest and the oldest  age customers
SELECT MIN(customer_age) lowest_age,
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

---=========================================================---
--------------------MEASURE EXPLORATION---------------------------
--------Calculate the key metrics of the business(Big numbers)----
---=========================================================---

--Find the Total sales
SELECT 
	SUM(sales_amount) total_sales
FROM gold.fact_sales

--Find how many items are sold
SELECT 
 SUM(quantity) total_items
FROM gold.fact_sales

--Find the average selling price
SELECT AVG(price) avg_price
FROM gold.fact_sales

--Find the total number of orders
SELECT COUNT(order_number) total_orders,
	   COUNT(DISTINCT(order_number)) total_orders
FROM gold.fact_sales

--Find the total number of customers
SELECT COUNT(customer_id) total_customers,
       COUNT(customer_key) total_customers
FROM gold.dim_customers

--Find the total number of products
SELECT  
	COUNT(product_key) product_count,
	COUNT(product_key) product_count
FROM gold.dim_products

--Find the total number of customers that has places an order
SELECT COUNT(DISTINCT(customer_key)) cust_count FROM gold.fact_sales

---===========================---
------------- REPORT-----------------
---===========================---

-- Generating the report by covering all the key metrics of the business
SELECT  'Total_sales' AS measure_name, SUM(sales_amount) measure_value FROM gold.fact_sales
UNION ALL
SELECT  'Total_number of items sold' AS measure_name, SUM(quantity) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'average_price' AS measure_name ,AVG(price) measure_value FROM gold.fact_sales
UNION ALL
SELECT --'Total Orders' AS measure_name ,COUNT(order_number)  measure_value 
       'Total Orders' AS measure_name ,COUNT(DISTINCT(order_number)) measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total Customers' AS measure_name ,COUNT(customer_id)  measure_value
       --COUNT(customer_key) total_customers
FROM gold.dim_customers
UNION ALL
SELECT
	'TotalProducts' AS measure_name ,COUNT(product_key) product_count
	--COUNT(product_key) product_count
FROM gold.dim_products
UNION ALL
SELECT 'Ordered Customers' AS measure_name ,COUNT(DISTINCT(customer_key)) measure_value FROM gold.fact_sales




---=========================================================---
--------------------MAGNITUDE ANALYSIS--------------------------
     --------Compares the measure values by categories----
	 -------- Analysed through MEASURE by CATEGORY--------
---=========================================================---

--Find the Total customers by countries
SELECT 
    country,
	COUNT(customer_key) customer_count
FROM gold.dim_customers
GROUP BY country
ORDER BY customer_count DESC

--Find the Total customers by gender
SELECT 
	gender,
	COUNT(customer_key) customer_count
FROM gold.dim_customers
GROUP BY gender
ORDER BY customer_count DESC

--Find he Total products by category
SELECT  
	category,
	COUNT(product_key) product_count
FROM gold.dim_products
GROUP BY category
ORDER BY product_count DESC

--What is the average cost in each category?
SELECT  
	category,
	AVG(product_cost) average_price
FROM gold.dim_products
GROUP BY category
ORDER BY average_price DESC

--What is the total revenue generate by each category?
SELECT  
	pd.category,
	SUM(sf.sales_amount) total_revenue
FROM gold.fact_sales sf
LEFT JOIN gold.dim_products pd
ON pd.product_key = sf.product_key
GROUP BY pd.category
ORDER BY total_revenue DESC

--Find the Total revenue generated by each customer?
SELECT  
	cd.customer_id,
	cd.firstname,
	cd.lastname,
	SUM(sf.sales_amount) total_revenue
FROM gold.fact_sales sf
LEFT JOIN gold.dim_customers cd
ON cd.customer_key = sf.customer_key
GROUP BY cd.customer_id,
	cd.firstname,
	cd.lastname
ORDER BY total_revenue DESC

--What is the distribution of sold items across the countries?
SELECT  
	cd.country,
	SUM(sf.quantity) total_items_sold
FROM gold.fact_sales sf
LEFT JOIN gold.dim_customers cd
ON cd.customer_key = sf.customer_key
GROUP BY country
ORDER BY total_items_sold DESC

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

--------------------------------------END TO EDA PROJECT PART-1--------------------------------------------------------------------

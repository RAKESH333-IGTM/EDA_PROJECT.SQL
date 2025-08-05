------------===============================================================------------
------------- ----------------------REPORT---------------------------------------------
---Generated a report by covering all the key metrics in the database tables-----------
------------================================================================-----------

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
	'TotalProducts' AS measure_name ,COUNT(product_key) AS product_count
	--COUNT(product_key) product_count
FROM gold.dim_products

UNION ALL

SELECT 'Ordered Customers' AS measure_name ,COUNT(DISTINCT(customer_key)) measure_value FROM gold.fact_sales

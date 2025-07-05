
---=========================================================---
--------------------MEASURE EXPLORATION---------------------------
--------Calculate the key metrics of the business(Big numbers)----
--------Formula used :- SUM(),AVG(),COUNT(),MIN(),MAX()---------
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
SELECT 
  AVG(price) avg_price
FROM gold.fact_sales

--Find the total number of orders
SELECT 
  COUNT(order_number) total_orders,
  COUNT(DISTINCT(order_number)) total_orders
FROM gold.fact_sales

--Find the total number of customers
SELECT 
  COUNT(customer_id) total_customers,
  COUNT(customer_key) total_customers
FROM gold.dim_customers

--Find the total number of products
SELECT  
	COUNT(product_key) product_count,
	COUNT(product_key) product_count
FROM gold.dim_products

--Find the total number of customers that has places an order
SELECT 
  COUNT(DISTINCT(customer_key)) cust_count 
FROM gold.fact_sales

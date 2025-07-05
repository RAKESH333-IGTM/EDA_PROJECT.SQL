--------=====================================================================----------
-----------SALES TABLE CREAIION IN VIEWS-------------------------------------------
--------=====================================================================----------

CREATE VIEW gold.fact_sales AS
	SELECT 
		sd.sls_ord_num order_number,
		pd.product_key,
		cd.customer_key,
		sd.sls_order_dt order_date,
		sd.sls_ship_dt shipping_date,
		sd.sls_due_dt due_date,
		sd.sls_sales sales_amount,
		sd.sls_quantity quantity,
		sd.sls_price price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pd
	ON sd.sls_prd_key = pd.product_number
	LEFT JOIN gold.dim_customers cd
	ON sd.sls_cust_id = cd.customer_id

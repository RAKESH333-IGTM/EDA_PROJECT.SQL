
--------=====================================================================----------
-----------CUSTOMERS TABLE CREATION IN VIEWS-------------------------------------------
--------=====================================================================----------

CREATE VIEW gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY ci.cst_id) customer_key,
	ci.cst_id customer_id,
	ci.cst_key customer_number,
	ci.cst_firstname  firstname,
	ci.cst_lastname lastname,
	la.cntry country,
	ci.cst_marital_status marital_status,
	CASE WHEN ci.cst_gndr != 'n/a'  THEN ci.cst_gndr
	     ELSE COALESCE(ca.gen,'n/a')
	END gender,
	ca.bdate birthdate,
	ci.cst_create_date create_date

FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid


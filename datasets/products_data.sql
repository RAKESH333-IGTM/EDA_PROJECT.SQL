--------=====================================================================----------
-----------PRODUCTS TABLE CREAIION IN VIEWS-------------------------------------------
--------=====================================================================----------

CREATE VIEW gold.dim_products AS
SELECT

    ROW_NUMBER() OVER(ORDER BY prd_start_dt,prd_key) product_key,
	pd.prd_id      product_id,
	pd.prd_key	   product_number,
	pd.prd_nm      product_name,
	pd.cat_id	   category_id,
	pc.cat		   category,
	pc.subcat      subcategory,
	pc.maintenance,
	pd.prd_cost    product_cost,
	pd.prd_line    product_line,
	pd.prd_start_dt product_start_date

FROM silver.crm_prd_info AS pd
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pd.cat_id = pc.id
WHERE prd_end_dt IS NULL


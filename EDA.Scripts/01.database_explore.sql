---=========================================================---
---------------DATA BASE EXPLORATION---------------------------
---=========================================================---

---- EXPLORING ALL OBJECTS IN THE DATA_BASE----

--- Exploring the tables with different Schemas in the Data Base---
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'VIEW'
--WHERE TABLE_SCHEMA = 'gold'  ---(Helps in exploring particular schema tables)
	

---EXPLORING ALL COLUMNS OF THE OBJECTS---
	---Helps in understanding presence of number of columns and their patterns---
SELECT  *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'

-- This SQL query retrieves the number of columns in each table
-- that exists within the 'gold' schema of the current database.
SELECT  
	TABLE_NAME,
	COUNT(*) columns_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'  -- Filter to include only tables from the 'gold' schema
GROUP BY TABLE_NAME	     -- Grouping the results by table name to count columns per table

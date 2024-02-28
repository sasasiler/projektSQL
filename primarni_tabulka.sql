CREATE OR REPLACE VIEW v_sasa_price_selection1 AS
SELECT ROUND(AVG(value), 2) AS average_price,
       category_code,
       YEAR (date_from) AS price_year
FROM czechia_price cp
WHERE cp.region_code IS NULL 
GROUP BY category_code, price_year
ORDER BY price_year, category_code 
;

CREATE OR REPLACE VIEW v_payrollplusindustrybranch1 AS
 SELECT cp.*, cpib.name AS industry_branch_name
 FROM czechia_payroll cp 
 LEFT JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
; 



CREATE OR REPLACE VIEW v_payroll_selection20_2_2024c AS
SELECT
   avg(value)AS average_payroll,
  payroll_year,
  industry_branch_code, 
  industry_branch_name
FROM
v_payrollplusindustrybranch1 vp 
WHERE
  value_type_code = 5958 AND payroll_year BETWEEN 2006 AND 2018
AND calculation_code = 100
  GROUP BY
  industry_branch_code,
  payroll_year
ORDER BY
  industry_branch_code,
  payroll_year
;  



CREATE OR REPLACE TABLE t_alexandra_silerova_project_sql_primary_final AS
SELECT
  vsps.price_year AS year,  
  vsps.average_price,
  cpc.code AS category_code_cpc,
  cpc.name AS category_name,
  #cpc.price_value,
  cpc.price_unit,
  vps.average_payroll,
  vps.industry_branch_code,
  vps.industry_branch_name
FROM
  v_sasa_price_selection1 vsps
LEFT JOIN
  czechia_price_category cpc ON cpc.code = vsps.category_code
LEFT JOIN
  v_payroll_selection20_2_2024c  vps ON vps.payroll_year = vsps.price_year; 
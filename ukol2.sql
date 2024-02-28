-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen
-- a mezd?

SELECT DISTINCT tas.year, 
                tas.average_payroll, 
                tas.average_price, 
                tas.price_unit, 
                tas.category_name,
                round(average_payroll / average_price, 2) AS no_units_per_payroll
FROM t_alexandra_silerova_project_sql_primary_final tas 
WHERE tas.year IN ('2006', '2018')
      AND category_name IN ('Mléko polotučné pasterované','Chléb konzumní kmínový' )
      AND tas.industry_branch_code IS NULL
GROUP BY tas.year, tas.category_name ;


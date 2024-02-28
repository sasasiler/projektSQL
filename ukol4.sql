
WITH avg_food_price AS (
    SELECT DISTINCT 
        year, 
        AVG(average_price) AS prumer_cen_potravin
    FROM t_alexandra_silerova_project_sql_primary_final
    GROUP BY YEAR
),
avg_payroll AS (
SELECT DISTINCT 
        year,
        average_payroll
    FROM t_alexandra_silerova_project_sql_primary_final 
    WHERE industry_branch_code IS NULL
)
SELECT 
    avg_food_price_cy.year,
    (avg_food_price_ny.prumer_cen_potravin - avg_food_price_cy.prumer_cen_potravin) / 
        avg_food_price_cy.prumer_cen_potravin * 100 AS prumer_cen_potravin_change,
    (avg_payroll_ny.average_payroll - avg_payroll_cy.average_payroll) / 
        avg_payroll_cy.average_payroll * 100 AS avg_payroll_change
FROM avg_food_price AS avg_food_price_cy
JOIN avg_food_price AS avg_food_price_ny
  ON avg_food_price_cy.year = avg_food_price_ny.year - 1
JOIN avg_payroll AS avg_payroll_cy
  ON avg_payroll_cy.year = avg_food_price_cy.year
JOIN avg_payroll AS avg_payroll_ny 
  ON avg_payroll_cy.year = avg_payroll_ny.year - 1
HAVING  prumer_cen_potravin_change > avg_payroll_change
;


# Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
# Otazka 1

CREATE OR REPLACE VIEW v_growth_of_wages AS 
WITH growthofwages AS (
    SELECT DISTINCT average_payroll, year, industry_branch_code 
    FROM t_alexandra_silerova_project_sql_primary_final
)
SELECT DISTINCT 
    tas.year,
    tas.average_payroll,
    tas2.average_payroll AS next_year_payroll,
    (tas2.average_payroll - tas.average_payroll) / tas.average_payroll * 100 AS payroll_diff_perc,
    tas.industry_branch_code,
    tas2.industry_branch_name 
FROM growthofwages tas
JOIN t_alexandra_silerova_project_sql_primary_final tas2
    ON tas.year = tas2.year - 1
    AND tas.industry_branch_code = tas2.industry_branch_code
#HAVING payroll_diff_perc < 0
ORDER BY tas.industry_branch_code, tas.year;


SELECT industry_branch_name,
#       year,
    CASE
        WHEN average_payroll < next_year_payroll THEN 'increased'
        ELSE 'decreased'
    END AS payroll_growth
FROM v_growth_of_wages
GROUP BY industry_branch_name, payroll_growth 
;





# Odpoved1: Ne, ve vyfiltrovanych odvetvich v danych letech mzdy mezirocne klesaly

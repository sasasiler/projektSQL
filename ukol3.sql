-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální 
-- meziroční nárůst)?


WITH 
pny AS (
    SELECT DISTINCT 
        average_price, 
        category_name, 
        category_code_cpc, 
        year  AS next_year
    FROM t_alexandra_silerova_project_sql_primary_final
)
SELECT DISTINCT  
    pi.year,
    pny.next_year,        
    ((pny.average_price-pi.average_price) / pi.average_price) * 100 AS price_change_perc,
    pi.category_name,
    pi.average_price AS av_price,
    pny.average_price AS next_year_price
FROM t_alexandra_silerova_project_sql_primary_final AS pi
JOIN pny
ON pi.category_name = pny.category_name
AND pi.year = pny.next_year - 1
ORDER BY price_change_perc ASC;


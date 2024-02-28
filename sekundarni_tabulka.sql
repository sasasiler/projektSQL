

-- Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a 
-- populací dalších evropských států ve stejném období, jako primární přehled pro ČR.


CREATE OR REPLACE TABLE t_alexandra_silerova_project_sql_secondary AS
 WITH country_part AS (
    SELECT country, population, continent
    FROM countries
),
economy_part AS (
    SELECT GDP, gini, `year`, country
    FROM economies
    WHERE YEAR BETWEEN 2006 AND 2018
)
SELECT DISTINCT  country_part.population, 
economy_part.country,
economy_part.GDP, economy_part.gini, economy_part.year
FROM country_part
LEFT JOIN economy_part ON country_part.country = economy_part.country
WHERE continent = 'Europe'
ORDER BY YEAR 
;





# Průvodní zpráva  Projekt  1 SQL

*Zpracovala* : Ing. Alexandra Šilerová  

**Zadání projektu**:  
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, 
že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin 
široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto 
informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené 
na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti 
potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států 
ve stejném období, jako primární přehled pro ČR.

Datové sady, které je možné použít pro získání vhodného datového podkladu.

### Primární tabulky
* `czechia_payroll` – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází 
z Portálu otevřených dat ČR.
* `czechia_payroll_calculation` – Číselník kalkulací v tabulce mezd.
* `czechia_payroll_industry_branch` – Číselník odvětví v tabulce mezd.
* `czechia_payroll_unit` – Číselník jednotek hodnot v tabulce mezd.
* `czechia_payroll_value_type` – Číselník typů hodnot v tabulce mezd.
* `czechia_price – Informace` o cenách vybraných potravin za několikaleté období. Datová sada pochází 
z Portálu otevřených dat ČR.
* `czechia_price_category` – Číselník kategorií potravin, které se vyskytují v našem přehledu.

Číselníky sdílených informací o ČR:

* `czechia_region` – Číselník krajů České republiky dle normy CZ-NUTS 2.
* `czechia_district` – Číselník okresů České republiky dle normy LAU.

### Dodatečné tabulky:

* `countries` - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo 
průměrná výška populace.
* `economies` - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.


### Výzkumné otázky:

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji 
v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

    
### Výstup projektu
Pomozte kolegům s daným úkolem. Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data 
dají získat. Tabulky pojmenujte `t_{jmeno}_{prijmeni}_project_SQL_primary_final` (pro data mezd a cen potravin 
za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a 
`t_{jmeno}_{prijmeni}_project_SQL_secondary_final` (pro dodatečná data o dalších evropských státech).
Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné 
otázky. Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! Záleží na tom, co říkají data.


## Příprava projektu
### Analýza otázek
Před tvorbou primární tabulky jsem analyzovala jednotlivé otázky zadání za cílem ujasnit si, jaká data budou 
v tabulce potřebná. Vytvořila jsem seznam potřebných položek a dle těchto jsem vybrala z poskytnutých 
datových podkladů vhodné tabulky ke kompozici primární tabulky číslo 1.

#### Tvorba primární tabulky
Primární tabulka vznikne spojením dat o cenách potravin a mzdách ve společných letech 2006-2018.
Navrhovaná tabulka bude mít sloupce: 
`year`, `average_price`, `category_code_cpc`, `category_name`, `price_unit`, `average_payroll`, 
`industry_branch_code`, `industry_branch_name`.

V části payroll jsem selektovala data jen od roku 2006 do 2018. Z důvodu porovnávání dat jsem z původního 
kvartálního členění filtrovala členění na celé roky pro dobrou srovnatelnost s připojenými daty cen potravin. 
Hodnoty mezd se zprůměrovaly na roční průměrný plat v jednotlivých odvětvích. 
Hodnoty týkající se počtu zaměstnanců jsem vyfiltrovala, jelikož zadané otázky se týkaly pouze platů.  

##### Část tabulky týkající se cen potravin 
V původní tabulce jsou ceny potravin odebírané několikrát ročně v různých regionech. 
Pro zjednodušení jsem ceny agregovala na průměrné roční ceny a vyfiltrovala z dat jen celorepublikové průměry cen. 
Jako časový interval jsem zvolila jednotku rok, a to zejména pro srovnání meziročního nárustu/poklesu. 

##### Část tabulky týkající se platů 
K základním tabulkám cen a platů (`czechia_payroll` a `czechia price`) jsem přidala i údaje o názvech jednotlivých 
průmyslových odvětvích a názvy kategorií potravin. Kvůli zmenšení objemu primární tabulky jsem nepřipojovala 
dodatečné tabulky `czechia_payroll_calculation`, `czechia_payroll_unit` a `czechia_payroll_value_type`. 
Vystačila jsem si s kódy nacházející se v hlavní tabulce. 
Jako `calculation code` jsem použila jen variantu **100** - fyzický počet zaměstnanců.
 
#### Tvorba sekundární tabulky
Tato tabulka měla vzniknout sloučením dat z tabulky economies a countries. Na základě zadání měla má obsahovat 
data o HDP, GINI koeficient a populaci dalších evropských států.

Z analýzy zadaných otázek vyplynulo, že k zodpovězení otázky č.5 bude třeba získat údaje o HDP v ČR v letech 2006 – 2018.
Navržená tabulka má sloupce: `population`, `country`, `GDP`, `gini`, `year`.  
Z původních tabulek jsem selektovala jen data pro evropský kontinent v letech 2008-16.

 
### Otázka 1
**Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

Ve všech odvětvích došlo v porovnání prvního a posledního roku zjišťovaného období k růstu. 
Žádný meziroční pokles nebyl během analyzovaného období zaznamenán jen v těchto odvětvích:

* Administrativní a podpůrné činnosti
* Doprava a skladování
* Ostatní činnosti
* Zdravotní a sociální péče
* Zpracovatelský průmysl

Ve zbylých odvětvích byl během daných let alespoň jeden pokles. Významný pokles mezd se projevil v období mezi lety 2012-2013. 
Tuto změnu pravděpodobně způsobila změna daňové legislativy.


### Otázka 2
**Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

K výpočtu jsem použila položku průměrná roční mzda, která byla v původní tabulce zaznamenaná jako mzda bez přiřazeného odvětví. 
Vzhledem k tomu, že nejsem schopná stanovit váhu jednotlivých odvětví pro vážený průměr, je tato možnost zatížená menší chybou. 

V roce 2006 byla průměrná měsíční mzda 18902 Kč.  Za tento plat bylo teoreticky možné nakoupit 1308 litrů mléka a 1172 kusů chleba.   
V roce 2018 byla průměrná měsíční mzda 30 998 Kč.  Za tento plat bylo teoreticky možné koupit 1563 litrů mléka a 1278 kusů chleba.   
Z vypočítaných hodnot plyne, že poměr platů a cen byl výhodnější v roce 2018, kdy bylo možné si z průměrné mzdy zakoupit více chleba i mléka. 

### Otázka 3
**Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší procentuální meziroční nárůst)?**

Z výsledků je patrné, že ceny některých produktů jsou poměrně nestabilní. Může se jednat o důsledek špatné sezóny v zemědělství.   
Největší výkyv ceny vykázala rajská jablka, jejichž cena v roce 2006 vystoupala na průměrnou cenu 58 Kč/kg a v roce 2007 o 30 % zlevnila. 
Stejná situace u rajčat byla znovu v roce 2010, kdy zlevnění činilo 28 %. 
Z dalších skokových poklesů cen lze zmínit zlevnění kategorie pečivo pšeničné bílé v roce 2009, 
které pravděpodobně souvisí se zlevněním mouky (23 %) v témže roce.
Při porovnání prvního a posledního roku stanoveného období, tj. 2006 a 2018 vykázala výrazné zlevnění položka cukr krystalový (27 %).

### Otázka 4
**Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**
 
K výpočtu jsem použila položku „průměrná cena všech potravin“ za jednotku rok a průměrnou roční mzdu, 
která byla v původní tabulce zaznamenaná jako mzda bez přiřazeného odvětví.
Obecně lze konstatovat, že neexistuje rok, kdy by byl meziroční nárust cen potravin výrazně vyšší než růst mezd 
(větší než 10 %). Z dat vyplývá, že meziroční nárust cen potravin byl vetší než růst mezd nejvíce o 5 % v roce 2012.

### Otázka 5
**Má výška HDP vliv na změny ve mzdách a cenách potravin? 
Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

Pro odpověď na otázku číslo 5 jsem využila data získaná z otázky číslo 4 a dále jsem připojila data týkající se změny daní ze sekundární tabulky. 
Výsledná analýza neodhalila výraznou korelaci mezi HDP a cenami potravin nebo mzdami, ani ve sledovaných letech, ani v následujícím období. 
Při omezení analýzy na situace s nárůstem přes 5 % jsem se zaměřila na období výrazného růstu HDP, cen nebo mzdových sazeb. 
Nejvýraznější nárůst HDP byl zaznamenán v roce 2006, dosahující 5.57%. V tomto období došlo k simultánnímu 
zvýšení cen potravin o 6.76 % a mzdových sazeb o 7.24%. 
Druhý nejvyšší růst HDP byl zaznamenán v roce 2014, dosahující 5.39%. V tomto roce však ceny potravin poklesly o 0.55 %, 
zatímco mzdové sazby vzrostly pouze o 3.17%. I v následujícím roce nebyl zaznamenán významný růst cen potravin ani mzdových sazeb.

Ze získaných dat není možné jednoznačně potvrdit, že výraznější růst HDP v jednom roce vždy vede k výraznějším 
růstům cen potravin či mezd ve stejném nebo následujícím roce. Vztahy se zdají být komplexní a ovlivněné dalšími faktory. 
Bylo by vhodné provést rozsáhlejší analýzu, které by mohly ovlivňovat tyto ekonomické ukazatele.

/*
# -------------------------------------------------
# Perform data aggregations and calculations
# -------------------------------------------------
*/

use dataman;
/*
# We can really speed things up by adding indexes!
*/

ALTER TABLE epest_high 
ADD INDEX year_state_county 
(`year`, `state_fips_code`, `county_fips_code`);
/*
# Took about 17.4 seconds.
*/

ALTER TABLE epest_low 
ADD INDEX year_state_county 
(`year`, `state_fips_code`, `county_fips_code`);
/*
# Took about 30.0 seconds
*/

/*
# -------------------------------------------------
# Combine low and high pesticide use values for WA
# -------------------------------------------------
*/

DROP TABLE IF EXISTS epest_combined_wa;
CREATE TABLE epest_combined_wa (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT l.compound AS compound, 
    l.year AS year, 
    l.state_fips_code AS state_fips_code, 
    l.county_fips_code AS county_fips_code, 
    l.low_use_kg AS low_use_kg, 
    h.high_use_kg AS high_use_kg 
FROM epest_low AS l INNER JOIN epest_high AS h 
ON (l.compound = h.compound 
    AND l.year = h.year 
    AND l.state_fips_code = h.state_fips_code 
    AND l.county_fips_code = h.county_fips_code) 
WHERE l.state_fips_code = 53;

/*
# -------------------------------------------------
# Alternative join: both versions take ~28 seconds
# -------------------------------------------------
#DROP TABLE IF EXISTS epest_combined_wa;
#CREATE TABLE epest_combined_wa (
#id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
#PRIMARY KEY (id)) 
#ENGINE=InnoDB 
#SELECT l.compound AS compound, 
#    l.year AS year, 
#    l.state_fips_code AS state_fips_code, 
#    l.county_fips_code AS county_fips_code, 
#    l.low_use_kg AS low_use_kg, 
#    h.high_use_kg AS high_use_kg 
#FROM epest_low AS l, epest_high AS h 
#WHERE l.compound = h.compound 
#    AND l.year = h.year 
#    AND l.state_fips_code = h.state_fips_code 
#    AND l.county_fips_code = h.county_fips_code 
#    AND l.state_fips_code = 53;

# So when we run the original "traditional" join, it only 
# takes about 27-29 seconds! Compare that to 16 minutes
# when the source tables have not been indexed.
*/

/*
# -------------------------------------------------
# Calculate low sum, mean, and count by year for WA
# -------------------------------------------------
*/

DROP TABLE IF EXISTS epest_low_wa_by_year;
CREATE TABLE epest_low_wa_by_year (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT year, 
SUM(low_use_kg) AS `wa_kg_low_sum`, 
AVG(low_use_kg) AS `wa_kg_low_mean`, 
COUNT(low_use_kg) AS `wa_kg_low_cnt` 
FROM epest_combined_wa 
GROUP BY year 
ORDER BY year;
SELECT * FROM epest_low_wa_by_year;

/*
# -------------------------------------------------
# Calculate CPF sum, mean, and count by year for WA
# -------------------------------------------------
*/

DROP TABLE IF EXISTS epest_cpf_low_wa_by_year;
CREATE TABLE epest_cpf_low_wa_by_year (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT year, 
SUM(low_use_kg) AS `wa_kg_low_sum`, 
AVG(low_use_kg) AS `wa_kg_low_mean`, 
COUNT(low_use_kg) AS `wa_kg_low_cnt` 
FROM epest_combined_wa 
WHERE compound = 'CHLORPYRIFOS' 
GROUP BY year 
ORDER BY year;
SELECT * FROM epest_cpf_low_wa_by_year;

/*
# -------------------------------------------------
# Find low and high pesticide use for WA state
# -------------------------------------------------
*/
DROP TABLE IF EXISTS epest_combined_yakima;
CREATE TABLE epest_combined_yakima (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT compound, 
    year, 
    state_fips_code, 
    county_fips_code, 
    low_use_kg, 
    high_use_kg 
FROM epest_combined_wa 
WHERE county_fips_code = 77;

/*
# -------------------------------------------------
# Calc. low sum, mean, and count by year for Yakima
# -------------------------------------------------
*/
DROP TABLE IF EXISTS epest_low_yakima_by_year;
CREATE TABLE epest_low_yakima_by_year (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT year, 
SUM(low_use_kg) AS `yakima_kg_low_sum`, 
AVG(low_use_kg) AS `yakima_kg_low_mean`, 
COUNT(low_use_kg) AS `yakima_kg_low_cnt` 
FROM epest_combined_yakima 
GROUP BY year 
ORDER BY year;
SELECT * FROM epest_low_yakima_by_year;

/*
# -------------------------------------------------
# Find low and high CPF use for WA state
# -------------------------------------------------
*/
DROP TABLE IF EXISTS epest_cpf_yakima_by_year;
CREATE TABLE epest_cpf_yakima_by_year (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT year, 
low_use_kg, 
high_use_kg 
FROM epest_combined_yakima 
WHERE compound = 'CHLORPYRIFOS' 
ORDER BY year;
SELECT * FROM epest_cpf_yakima_by_year;

/*
# -------------------------------------------------
# Compare (%) Yakima CPF use to state total for WA
# -------------------------------------------------
*/
DROP TABLE IF EXISTS epest_low_yakima_percent_of_total_cpf_by_year;
CREATE TABLE epest_low_yakima_percent_of_total_cpf_by_year (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT y.year AS year, 
    y.low_use_kg AS yakima_kg, 
    t.wa_kg_low_sum AS wa_kg, 
    CONCAT(ROUND(( y.low_use_kg/t.wa_kg_low_sum * 100 ),2),'%') AS `perc`
FROM epest_cpf_yakima_by_year y 
JOIN epest_cpf_low_wa_by_year t 
ON t.year = y.year 
ORDER BY year;
SELECT * FROM epest_low_yakima_percent_of_total_cpf_by_year;

/*
# -------------------------------------------------
# Compare low and high CPF use for Yakima by year
# -------------------------------------------------
*/
DROP TABLE IF EXISTS epest_yakima_cpf_low_vs_high;
CREATE TABLE epest_yakima_cpf_low_vs_high (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id)) 
ENGINE=InnoDB 
SELECT year, 
    low_use_kg, 
    high_use_kg 
FROM epest_combined_wa 
WHERE state_fips_code = 53 
    AND county_fips_code = 77 
    AND compound = 'CHLORPYRIFOS' 
ORDER BY year;
SELECT * FROM epest_yakima_cpf_low_vs_high;

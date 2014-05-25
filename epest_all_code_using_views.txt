use dataman;

DROP TABLE IF EXISTS `dataman`.`epest_high` ;

CREATE  TABLE IF NOT EXISTS `dataman`.`epest_high` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `compound` VARCHAR(45) NULL ,
  `year` YEAR(4) NULL ,
  `state_fips_code` SMALLINT NULL ,
  `county_fips_code` SMALLINT NULL,
  `high_use_kg` FLOAT(8,1) NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

DROP TABLE IF EXISTS `dataman`.`epest_low` ;

CREATE  TABLE IF NOT EXISTS `dataman`.`epest_low` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `compound` VARCHAR(45) NULL ,
  `year` YEAR(4) NULL ,
  `state_fips_code` SMALLINT NULL ,
  `county_fips_code` SMALLINT NULL,
  `low_use_kg` FLOAT(8,1) NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

LOAD DATA INFILE '/Data/high/EPest.high.county.estimates.txt' 
INTO TABLE epest_high 
(compound, year, state_fips_code, county_fips_code, high_use_kg);

LOAD DATA INFILE '/Data/high/EPest.low.county.estimates.txt' 
INTO TABLE epest_low 
(compound, year, state_fips_code, county_fips_code, low_use_kg);

ALTER TABLE epest_high 
ADD INDEX year_state_county 
(`year`, `state_fips_code`, `county_fips_code`);

ALTER TABLE epest_low 
ADD INDEX year_state_county 
(`year`, `state_fips_code`, `county_fips_code`);

CREATE VIEW epest_low_wa_by_year_view AS 
SELECT year, 
SUM(low_use_kg) AS `wa_kg_low_sum`, 
AVG(low_use_kg) AS `wa_kg_low_mean`, 
COUNT(low_use_kg) AS `wa_kg_low_cnt` 
FROM epest_low  
WHERE state_fips_code = 53
GROUP BY year 
ORDER BY year;

SELECT * FROM epest_low_wa_by_year_view;

CREATE VIEW epest_cpf_low_wa_by_year_view AS 
SELECT year, 
SUM(low_use_kg) AS `wa_kg_low_sum`, 
AVG(low_use_kg) AS `wa_kg_low_mean`, 
COUNT(low_use_kg) AS `wa_kg_low_cnt` 
FROM epest_low  
WHERE compound = 'CHLORPYRIFOS' 
AND state_fips_code = 53
GROUP BY year 
ORDER BY year;

SELECT * FROM epest_cpf_low_wa_by_year_view;

SELECT year, 
SUM(low_use_kg) AS `yakima_kg_low_sum`, 
AVG(low_use_kg) AS `yakima_kg_low_mean`, 
COUNT(low_use_kg) AS `yakima_kg_low_cnt` 
FROM epest_low 
WHERE state_fips_code = 53 
    AND county_fips_code = 77 
GROUP BY year 
ORDER BY year;

CREATE VIEW epest_cpf_yakima_by_year_view AS 
SELECT l.year AS year,  
    l.low_use_kg AS low_use_kg, 
    h.high_use_kg AS high_use_kg 
FROM epest_low AS l INNER JOIN epest_high AS h 
ON (l.compound = h.compound 
    AND l.year = h.year 
    AND l.state_fips_code = h.state_fips_code 
    AND l.county_fips_code = h.county_fips_code) 
WHERE l.state_fips_code = 53 
    AND l.county_fips_code = 77 
    AND l.compound = 'CHLORPYRIFOS' 
ORDER BY year;

SELECT * FROM epest_cpf_yakima_by_year_view;

SELECT y.year AS year, 
    y.low_use_kg AS yakima_kg, 
    t.wa_kg_low_sum AS wa_kg, 
    CONCAT(ROUND(( y.low_use_kg/t.wa_kg_low_sum * 100 ),2),'%') AS `perc`
FROM epest_cpf_yakima_by_year_view y 
JOIN epest_cpf_low_wa_by_year_view t 
ON t.year = y.year 
ORDER BY year;

Data Management
========================================================

For Scientific Research

[//]: # (author: Brian High, UW DEOHS)
[//]: # (date: 2014-05-22)
[//]: # (license: CC0 1.0 Universal,linked-content/images)
[//]: # (note: License does not apply to external content such as quoted material, linked web pages, images, or videos. These are licensed separately by their authors, publishers or other copyright holders. See attribution links for details.)
[//]: # (note: Any of the trademarks, service marks, collective marks, design rights, personality rights, or similar rights that are mentioned, used, or cited in the presentations and wiki of the Data Management For Scientific Research workshop/course are the property of their respective owners.)
[//]: # (homepage: https://github.com/brianhigh/data-workshop)

<p style="width: 600px; float: right; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://www.stanza.co.uk/body/stanza_+BODY-copy.jpg" alt="stanza body copy" style="padding-bottom:0.5em;" />Photo: &copy; <a href="http://www.stanza.co.uk/body/index.html">Stanza</a>. Used with permission.</p>

Session 7: Applied SQL
========================================================

Today we will be applying our data cleanup and SQL skills to our current research projects.

<p style="width: 500px; float: left; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/SQL_ANATOMY_wiki.svg/500px-SQL_ANATOMY_wiki.svg.png" alt="SQL anatomy" style="padding-bottom:0.5em;" />Image: <a href="http://commons.wikimedia.org/wiki/File:SQL_ANATOMY_wiki.svg">SqlPac / Ferdna / Wikimedia</a></p>


Example: Estimated Pesticide Use
========================================================

We want to download some files from the USGS listing estimated pesticide use in the United States.

http://pubs.usgs.gov/ds/752/

From these files, we want to ...

* Produce statewide yearly pesticide totals

* Compare "high" and "low" [chlorpyrifos](http://en.wikipedia.org/wiki/Chlorpyrifos) (CPF) use

---

<p style="width: 320px; float: left; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Chlorpyrifos-3D-vdW.png/320px-Chlorpyrifos-3D-vdW.png" alt="CPF molecule" style="padding-bottom:0.5em;" />Image: <a href="http://en.wikipedia.org/wiki/File:Chlorpyrifos-3D-vdW.png"> Benjah-bmm27 / Wikimedia</a></p>

Download the Files
========================================================

While we could manually download each text file from the website, on by one, we are going to automate this process.

Here is one way to grab all of those text files with one Bash shell command:

```
wget -q --no-parent \
     -e robots=off \
     --recursive \
     --accept=txt \
     --no-directories \
     http://pubs.usgs.gov/ds/752/
```

This can be pasted into the Bash shell and run as one multiline command.

You will download 14 text files totalling about 266 MB in size.

Combine the Files
========================================================

We can use a Bash command loop to combine the "high" pesticide use and "low" use files. 

"High" and "low" represent the two different [EPest Methods](http://water.usgs.gov/nawqa/pnsp/usage/maps/about.php) that we want to compare.

In our ```for``` loop we will ```use tail -n +2``` to skip the first line of each file.

```
for i in high low; do \
    tail -q -n +2 \
        EPest.${i}.*.table*.txt > \
        EPest.${i}.county.estimates.txt
done
```

Now we have a file for "high" and another file for "low".

Create Database Tables
========================================================

Run these commands in MySQL:

```
CREATE  TABLE IF NOT EXISTS `epest_high` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `compound` VARCHAR(45) NULL,
  `year` YEAR(4) NULL,
  `state_fips_code` SMALLINT NULL,
  `county_fips_code` SMALLINT NULL,
  `high_use_kg` NUMERIC(8,1) NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE  TABLE IF NOT EXISTS `epest_low` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `compound` VARCHAR(45) NULL,
  `year` YEAR(4) NULL,
  `state_fips_code` SMALLINT NULL,
  `county_fips_code` SMALLINT NULL,
  `low_use_kg` NUMERIC(8,1) NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;
```

Import the Data
========================================================

Copy the two combined files to /Data/high/ and import them.

Bash:

```
cp EPest.*.county.estimates.txt /Data/high/
```

MySQL:

```
LOAD DATA INFILE 
'/Data/high/EPest.high.county.estimates.txt' 
INTO TABLE epest_high 
(compound, year, state_fips_code, county_fips_code, high_use_kg);

LOAD DATA INFILE 
'/Data/high/EPest.low.county.estimates.txt' 
INTO TABLE epest_low 
(compound, year, state_fips_code, county_fips_code, low_use_kg);
```

Add Indexes to Tables for Performance
========================================================

This will speed up our later queries.

MySQL:

```
ALTER TABLE epest_high 
ADD INDEX year_state_county 
(`year`, `state_fips_code`, `county_fips_code`);

ALTER TABLE epest_low 
ADD INDEX year_state_county 
(`year`, `state_fips_code`, `county_fips_code`);
```

Find Annual "EPest Low" Use in WA
========================================================

```
SELECT year, 
SUM(low_use_kg) AS `wa_kg_low_sum`, 
AVG(low_use_kg) AS `wa_kg_low_mean`, 
COUNT(low_use_kg) AS `wa_kg_low_cnt` 
FROM epest_low  
WHERE state_fips_code = 53
GROUP BY year 
ORDER BY year;
```

![epest low wa by year view](images/epest_low_wa_by_year_view.png)

Save that Query as a View
========================================================

```
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
```

![epest low wa by year view](images/epest_low_wa_by_year_view.png)

Create a View for EPest Low WA CPF Use
========================================================

```
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
```

![epest cpf low wa by year view](images/epest_cpf_low_wa_by_year_view.png)

Analyze EPest Low CPF use in Yakima Co.
=========================================================

```
SELECT year, 
SUM(low_use_kg) AS `yakima_kg_low_sum`, 
AVG(low_use_kg) AS `yakima_kg_low_mean`, 
COUNT(low_use_kg) AS `yakima_kg_low_cnt` 
FROM epest_low 
WHERE state_fips_code = 53 
    AND county_fips_code = 77 
GROUP BY year 
ORDER BY year;
```

![epest low cpf yakima](images/epest_low_cpf_yakima.png)

Compare High and Low for Yakima Co.
=========================================================

```
CREATE VIEW epest_cpf_yakima_by_year_view AS 
SELECT l.year AS year,  
    l.low_use_kg AS low_use_kg, 
    h.high_use_kg AS high_use_kg 
FROM epest_low AS l 
    INNER JOIN epest_high AS h 
ON (l.compound = h.compound 
    AND l.year = h.year 
    AND l.state_fips_code = h.state_fips_code 
    AND l.county_fips_code = h.county_fips_code) 
WHERE l.state_fips_code = 53 
    AND l.county_fips_code = 77 
    AND l.compound = 'CHLORPYRIFOS' 
ORDER BY year;

SELECT * FROM epest_cpf_yakima_by_year_view;
```

![epest cpf yakima by year view](images/epest_cpf_yakima_by_year_view.png)

Compare Yakima CPF Use to WA
=========================================================

```
SELECT y.year AS year, 
    y.low_use_kg AS yakima_kg, 
    t.wa_kg_low_sum AS wa_kg, 
    CONCAT(ROUND(( y.low_use_kg/t.wa_kg_low_sum * 100 ),2),'%') AS `perc`
FROM epest_cpf_yakima_by_year_view y 
JOIN epest_cpf_low_wa_by_year_view t 
ON t.year = y.year 
ORDER BY year;
```

![low cpf yakima wa](images/epest_low_cpf_yakima_percent_wa.png)


Hands-on Group Exercise
========================================================

We will work some more with this database and produce some plots.

![r ggplot](images/rggplot.png)


Discussion
========================================================

We will discuss your SQL queries and plots.

<p style="width: 275px; float: left; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://upload.wikimedia.org/wikipedia/commons/e/eb/User_journey_discussion.png" alt="discussion" style="padding-bottom:0.5em;" />Graphic: <a href="http://upload.wikimedia.org/wikipedia/commons/e/eb/User_journey_discussion.png">Jagbirlehl / Wikimedia</a></p>


Connecting from R
========================================================

```{sql}
install.packages("RMySQL")
library("RMySQL")

drv <- dbDriver("MySQL")
myconn <- dbConnect(drv, host="plasmid.deohs.washington.edu", 
                    dbname="dataman", 
                    user="USERNAME", 
                    password="PASSWORD")
```                    


Complete R Script Using ggplot2
=======================================================

![r ggplot script](images/rggplot_code.png)


R Plot Using ggplot2
=======================================================

![r ggplot](images/rggplot.png)

```
ggplot(lowhighdat, aes(x=YEAR, y=KG, colour=EPest, group=EPest)) +
  geom_line() + ggtitle(title)
```
---

![epest cpf yakima by year view complete](images/epest_cpf_yakima_by_year_view_complete.png)



In the Coming Sessions...
========================================================

* Project Management
* Version Control
* Data Security
* Systems Administration

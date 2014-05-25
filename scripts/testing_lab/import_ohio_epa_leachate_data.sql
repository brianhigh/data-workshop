/* Import script for Ohio EPA Data into our Lab Sample Testing database */

/* Last updated by BKH on 2014-05-23. */

/* For this example, we are assumging that the database name is "high". */

USE high;

/* We will assume that the empty database and empty tables have been
   created from the schema file or from the Database -> Forward Engineer
   feature of MySQL Workbench. This includes all of the tables of the data
   model plus the intermediate "bucket" table used for importing. */

/* Import the external data from a tab-delimited file, previously prepared. */

LOAD DATA INFILE '/Data/high/n_cdd_leachate_sample_data_formatted.txt' 
INTO TABLE bucket 
IGNORE 1 LINES; 

/* Add foreign keys to the intermediate "bucket" table */

ALTER TABLE bucket ADD `analyte_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `client_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `disposal_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `instrument_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `matrix_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `parm_type_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `prep_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `prep_method_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `qc_type_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `sample_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `technician_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `test_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `test_method_id` INT UNSIGNED NULL;
ALTER TABLE bucket ADD `unit_id` INT UNSIGNED NULL;

/* Add indexes for better performance */

ALTER TABLE test_methods ADD INDEX test_methods_name (`name`);
ALTER TABLE analytes ADD INDEX analytes_name (`name`);
ALTER TABLE units ADD INDEX units_name (`name`);
ALTER TABLE prep_methods ADD INDEX prep_methods_name (`name`);
ALTER TABLE samples ADD INDEX samples_name (`name`);
ALTER TABLE technicians ADD INDEX technicians_name (`name`);
ALTER TABLE qc_types ADD INDEX qc_types_name (`name`);
ALTER TABLE matrices ADD INDEX matrices_name (`name`);
ALTER TABLE sdgs ADD INDEX sdgs_name (`name`);

/* Do some last-minute data cleanup */

/* Fill in empty or unknown prep methods with analysis method. */
UPDATE bucket SET prepmethodref = methodref
WHERE prepmethodref = "" OR prepmethodref = "METHOD";

/* Make all analysts uppercase since they are just "initials" */ 
UPDATE bucket SET `analyst` = UCASE(`analyst`);


/* Move data from "bucket" to main tables of data model. */

/* For the tables which do not depend on other tables (and have no 
   foreign keys), simply INSERT the data with a SELECT DISTINCT 
   from bucket. */

INSERT INTO clients (`name`) 
    SELECT DISTINCT clientname FROM bucket;

INSERT INTO qc_types (`name`) 
    SELECT DISTINCT qctype FROM bucket;

INSERT INTO matrices (`name`) 
    SELECT DISTINCT matrix FROM bucket;

INSERT INTO parm_types (`name`) 
    SELECT DISTINCT parm_type FROM bucket;

INSERT INTO prep_methods (`name`) 
    SELECT DISTINCT prepmethodref FROM bucket;

INSERT INTO test_methods (`name`) 
    SELECT DISTINCT methodref FROM bucket;

INSERT INTO units (`name`) 
    SELECT DISTINCT units FROM bucket;

INSERT INTO technicians (`name`) 
    SELECT DISTINCT analyst FROM bucket;

INSERT INTO analytes (`name`, `cas_number`) 
    SELECT DISTINCT parm_syn, cas_no FROM bucket;

/* For the rest of the tables, we need a JOIN to fill foreign key values 
   from other tables */

INSERT INTO sdgs (`name`, `datetime_received`, `client_id`) 
    SELECT DISTINCT b.core_id, b.receivedate, c.id 
    FROM bucket b INNER JOIN clients c ON
    b.clientname = c.name;

INSERT INTO samples (
    `name`, 
    `datetime_collected`, 
    `client_sample_name`, 
    `qc_type_id`, 
    `matrix_id`, 
    `sdg_id`) 
    SELECT DISTINCT b.labsampid, b.collection_date, b.clientsampid, q.id, m.id, s.id 
    FROM bucket b 
    INNER JOIN qc_types q ON b.qctype = q.name 
    INNER JOIN matrices m ON b.matrix = m.name 
    INNER JOIN sdgs s ON b.core_id = s.name;

/* For the rest of the tables, we will first fill the foreign keys in
   the bucket table before we copy the data to the destination table. 
   We are doing this to avoid duplication which may result from the other
   approach, as the joins get more complicated and our choice of source 
   fields may not guarantee uniqueness. */

UPDATE bucket 
    INNER JOIN prep_methods p ON prepmethodref = p.name 
    INNER JOIN samples s ON labsampid = s.name 
    INNER JOIN technicians t ON analyst = t.name
SET prep_method_id = p.id, sample_id = s.id, technician_id = t.id;


/* The rest of the tables use a concatenated "name" for the convenience 
   of the lab technicians who need to label sample containers. These
   present problems with repect to normalization, of course, as there
   could be update anomalies if the concatenated fields change after
   the concatenation is performed. This is a compromize so that there
   is a meaningful ID for the technicians to use instead of an auto-numbered
   ID field. Ideally, the "name" field would not be necessary. */

INSERT INTO preps (
    `name`, 
    `datetime`, 
    `prep_method_id`, 
    `sample_id`, 
    `technician_id`) 
    SELECT DISTINCT CONCAT_WS("-",labsampid,prepbatch), 
        extract_date, prep_method_id, sample_id, technician_id 
    FROM bucket;

UPDATE bucket b 
    INNER JOIN preps p ON CONCAT_WS("-",b.labsampid,b.prepbatch) = p.name 
    INNER JOIN test_methods m ON b.methodref = m.name
    INNER JOIN technicians t ON b.analyst = t.name
SET b.prep_id = p.id, b.test_method_id = m.id, b.technician_id = t.id;

INSERT INTO tests (
    `name`, 
    `datetime`, 
    `dilution`, 
    `prep_id`, 
    `test_method_id`, 
    `technician_id`) 
    SELECT DISTINCT CONCAT_WS("-",labsampid,prepbatch,methodref), 
    run_date, 
    dilution, 
    prep_id, 
    test_method_id, 
    technician_id 
    FROM bucket;

UPDATE bucket b 
    INNER JOIN units u ON b.units = u.name 
    INNER JOIN analytes a ON b.parm_syn = a.name
    INNER JOIN tests t ON CONCAT_WS("-",b.labsampid,b.prepbatch,b.methodref) = t.name
    INNER JOIN parm_types p ON b.parm_type = p.name
SET b.unit_id = u.id, b.analyte_id = a.id, b.test_id = t.id, b.parm_type_id = p.id;

INSERT INTO test_results (
    `value`, 
    `flag`, 
    `unit_id`, 
    `analyte_id`, 
    `test_id`,
    `parm_type_id`,  
    `mdl`, 
    `rl`) 
    SELECT numvalue, 
        qual, 
        unit_id, 
        analyte_id, 
        test_id,  
        parm_type_id, 
        mdlvalue, 
        rdlvalue 
    FROM bucket;

DROP TABLE bucket;

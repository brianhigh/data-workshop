/*
# -------------------------------------------------
# Import high and low pesticide use data from TSV
# -------------------------------------------------
*/

use dataman;

LOAD DATA INFILE '/Data/high/EPest.high.county.estimates.txt' 
INTO TABLE epest_high 
(compound, year, state_fips_code, county_fips_code, high_use_kg);

LOAD DATA INFILE '/Data/high/EPest.low.county.estimates.txt' 
INTO TABLE epest_low 
(compound, year, state_fips_code, county_fips_code, low_use_kg);

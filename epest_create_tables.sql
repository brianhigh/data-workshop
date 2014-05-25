# -------------------------------------------------
# Create tables to store high and low pesticide use
# -------------------------------------------------

use dataman;

-- -----------------------------------------------------
-- Table `dataman`.`epest_high`
-- -----------------------------------------------------
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

-- -----------------------------------------------------
-- Table `dataman`.`epest_low`
-- -----------------------------------------------------
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

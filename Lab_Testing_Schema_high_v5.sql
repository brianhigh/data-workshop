SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `high` ;
CREATE SCHEMA IF NOT EXISTS `high` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `high` ;

-- -----------------------------------------------------
-- Table `high`.`technicians`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`technicians` ;

CREATE  TABLE IF NOT EXISTS `high`.`technicians` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`prep_methods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`prep_methods` ;

CREATE  TABLE IF NOT EXISTS `high`.`prep_methods` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(100) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`qc_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`qc_types` ;

CREATE  TABLE IF NOT EXISTS `high`.`qc_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`matrices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`matrices` ;

CREATE  TABLE IF NOT EXISTS `high`.`matrices` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`clients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`clients` ;

CREATE  TABLE IF NOT EXISTS `high`.`clients` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `billing_address` VARCHAR(100) NULL ,
  `shipping_address` VARCHAR(100) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`sdgs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`sdgs` ;

CREATE  TABLE IF NOT EXISTS `high`.`sdgs` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `client_id` INT UNSIGNED NOT NULL ,
  `technician_id` INT UNSIGNED NULL ,
  `datetime_received` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_sdgs_clients1` (`client_id` ASC) ,
  INDEX `fk_sdgs_technicians1` (`technician_id` ASC) ,
  CONSTRAINT `fk_sdgs_clients1`
    FOREIGN KEY (`client_id` )
    REFERENCES `high`.`clients` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sdgs_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `high`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`samples`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`samples` ;

CREATE  TABLE IF NOT EXISTS `high`.`samples` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `datetime_collected` DATETIME NULL ,
  `client_sample_name` VARCHAR(45) NULL ,
  `qc_type_id` INT UNSIGNED NOT NULL ,
  `matrix_id` INT UNSIGNED NOT NULL ,
  `sdg_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_samples_qc_types1` (`qc_type_id` ASC) ,
  INDEX `fk_samples_matrices1` (`matrix_id` ASC) ,
  INDEX `fk_samples_sdgs1` (`sdg_id` ASC) ,
  CONSTRAINT `fk_samples_qc_types1`
    FOREIGN KEY (`qc_type_id` )
    REFERENCES `high`.`qc_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_matrices1`
    FOREIGN KEY (`matrix_id` )
    REFERENCES `high`.`matrices` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_sdgs1`
    FOREIGN KEY (`sdg_id` )
    REFERENCES `high`.`sdgs` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`units`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`units` ;

CREATE  TABLE IF NOT EXISTS `high`.`units` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`preps`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`preps` ;

CREATE  TABLE IF NOT EXISTS `high`.`preps` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `quantity` VARCHAR(45) NULL ,
  `datetime` DATETIME NULL ,
  `initial_volume_ml` DECIMAL(7,4) NULL ,
  `initial_mass_g` DECIMAL(9,5) NULL ,
  `prep_method_id` INT UNSIGNED NOT NULL ,
  `sample_id` INT UNSIGNED NOT NULL ,
  `technician_id` INT UNSIGNED NOT NULL ,
  `unit_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_preps_prep_methods1` (`prep_method_id` ASC) ,
  INDEX `fk_preps_samples1` (`sample_id` ASC) ,
  INDEX `fk_preps_technicians1` (`technician_id` ASC) ,
  INDEX `fk_preps_units1` (`unit_id` ASC) ,
  CONSTRAINT `fk_preps_prep_methods1`
    FOREIGN KEY (`prep_method_id` )
    REFERENCES `high`.`prep_methods` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_preps_samples1`
    FOREIGN KEY (`sample_id` )
    REFERENCES `high`.`samples` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_preps_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `high`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_preps_units1`
    FOREIGN KEY (`unit_id` )
    REFERENCES `high`.`units` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`test_methods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`test_methods` ;

CREATE  TABLE IF NOT EXISTS `high`.`test_methods` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(100) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`tests`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`tests` ;

CREATE  TABLE IF NOT EXISTS `high`.`tests` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `datetime` DATETIME NOT NULL ,
  `dilution` DECIMAL(10,3) NOT NULL DEFAULT 1.000 ,
  `prep_id` INT UNSIGNED NOT NULL ,
  `test_method_id` INT UNSIGNED NOT NULL ,
  `technician_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_tests_preps1` (`prep_id` ASC) ,
  INDEX `fk_tests_test_methods1` (`test_method_id` ASC) ,
  INDEX `fk_tests_technicians1` (`technician_id` ASC) ,
  CONSTRAINT `fk_tests_preps1`
    FOREIGN KEY (`prep_id` )
    REFERENCES `high`.`preps` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tests_test_methods1`
    FOREIGN KEY (`test_method_id` )
    REFERENCES `high`.`test_methods` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tests_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `high`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`analytes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`analytes` ;

CREATE  TABLE IF NOT EXISTS `high`.`analytes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `cas_number` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`parm_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`parm_types` ;

CREATE  TABLE IF NOT EXISTS `high`.`parm_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`test_results`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`test_results` ;

CREATE  TABLE IF NOT EXISTS `high`.`test_results` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `value` DECIMAL(12,7) NULL ,
  `flag` VARCHAR(8) NULL ,
  `unit_id` INT UNSIGNED NOT NULL ,
  `analyte_id` INT UNSIGNED NOT NULL ,
  `test_id` INT UNSIGNED NOT NULL ,
  `parm_type_id` INT UNSIGNED NOT NULL ,
  `mdl` DECIMAL(12,7) NULL ,
  `rl` DECIMAL(12,7) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_test_results_units1` (`unit_id` ASC) ,
  INDEX `fk_test_results_analytes1` (`analyte_id` ASC) ,
  INDEX `fk_test_results_tests1` (`test_id` ASC) ,
  INDEX `fk_test_results_parm_types1` (`parm_type_id` ASC) ,
  CONSTRAINT `fk_test_results_units1`
    FOREIGN KEY (`unit_id` )
    REFERENCES `high`.`units` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_results_analytes1`
    FOREIGN KEY (`analyte_id` )
    REFERENCES `high`.`analytes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_results_tests1`
    FOREIGN KEY (`test_id` )
    REFERENCES `high`.`tests` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_results_parm_types1`
    FOREIGN KEY (`parm_type_id` )
    REFERENCES `high`.`parm_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `high`.`bucket`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `high`.`bucket` ;

CREATE  TABLE IF NOT EXISTS `high`.`bucket` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `clientname` VARCHAR(45) NULL ,
  `labsampid` VARCHAR(45) NULL ,
  `core_id` VARCHAR(45) NULL ,
  `clientsampid` VARCHAR(45) NULL ,
  `collection_date` DATETIME NULL ,
  `qctype` VARCHAR(45) NULL ,
  `parm_type` VARCHAR(45) NULL ,
  `parm_syn` VARCHAR(45) NULL ,
  `numvalue` DECIMAL(12,7) NULL ,
  `units` VARCHAR(10) NULL ,
  `qual` VARCHAR(8) NULL ,
  `rdlvalue` DECIMAL(12,7) NULL ,
  `dilution` DECIMAL(10,3) NULL ,
  `cas_no` VARCHAR(45) NULL ,
  `methodref` VARCHAR(45) NULL ,
  `prepmethodref` VARCHAR(45) NULL ,
  `matrix` VARCHAR(45) NULL ,
  `extract_date` DATE NULL ,
  `run_date` DATETIME NULL ,
  `prepbatch` VARCHAR(45) NULL ,
  `analyst` VARCHAR(45) NULL ,
  `receivedate` DATE NULL ,
  `mdlvalue` DECIMAL(12,7) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

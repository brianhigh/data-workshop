SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `expolab` ;
CREATE SCHEMA IF NOT EXISTS `expolab` DEFAULT CHARACTER SET utf8 ;
USE `expolab` ;

-- -----------------------------------------------------
-- Table `expolab`.`positions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`positions` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`positions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`subjects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`subjects` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`subjects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fname` VARCHAR(45) NOT NULL ,
  `lname` VARCHAR(45) NOT NULL ,
  `gender` CHAR(1) NULL ,
  `birthdate` DATE NULL ,
  `position_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_subjects_positions1` (`position_id` ASC) ,
  CONSTRAINT `fk_subjects_positions1`
    FOREIGN KEY (`position_id` )
    REFERENCES `expolab`.`positions` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`body_locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`body_locations` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`body_locations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`subject_locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`subject_locations` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`subject_locations` (
  `id` INT UNSIGNED NOT NULL ,
  `subjects_id` INT UNSIGNED NOT NULL ,
  `body_locations_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_subject_locations_subjects1` (`subjects_id` ASC) ,
  INDEX `fk_subject_locations_body_locations1` (`body_locations_id` ASC) ,
  CONSTRAINT `fk_subject_locations_subjects1`
    FOREIGN KEY (`subjects_id` )
    REFERENCES `expolab`.`subjects` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subject_locations_body_locations1`
    FOREIGN KEY (`body_locations_id` )
    REFERENCES `expolab`.`body_locations` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`buildings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`buildings` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`buildings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  `addr1` VARCHAR(45) NOT NULL ,
  `addr2` VARCHAR(45) NULL ,
  `city` VARCHAR(45) NOT NULL ,
  `state` VARCHAR(45) NOT NULL ,
  `zip` VARCHAR(45) NOT NULL ,
  `country` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`geo_locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`geo_locations` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`geo_locations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `desc` VARCHAR(45) NULL ,
  `lat` FLOAT NULL ,
  `lon` FLOAT NULL ,
  `floor` VARCHAR(45) NULL ,
  `room` VARCHAR(45) NULL ,
  `subject_location_id` INT UNSIGNED NULL ,
  `building_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_geo_locations_subject_locations1` (`subject_location_id` ASC) ,
  INDEX `fk_geo_locations_buildings1` (`building_id` ASC) ,
  CONSTRAINT `fk_geo_locations_subject_locations1`
    FOREIGN KEY (`subject_location_id` )
    REFERENCES `expolab`.`subject_locations` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_geo_locations_buildings1`
    FOREIGN KEY (`building_id` )
    REFERENCES `expolab`.`buildings` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`technicians`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`technicians` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`technicians` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fname` VARCHAR(45) NOT NULL ,
  `lname` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`sample_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`sample_types` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`sample_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`samples`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`samples` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`samples` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `temperature` FLOAT NULL ,
  `humidity` FLOAT NULL ,
  `comment` VARCHAR(45) NULL ,
  `id_code` VARCHAR(45) NOT NULL ,
  `geo_location_id` INT UNSIGNED NOT NULL ,
  `sample_type_id` INT UNSIGNED NOT NULL ,
  `technician_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_samples_geo_locations1` (`geo_location_id` ASC) ,
  INDEX `fk_samples_technicians1` (`technician_id` ASC) ,
  INDEX `fk_samples_sample_types1` (`sample_type_id` ASC) ,
  CONSTRAINT `fk_samples_geo_locations1`
    FOREIGN KEY (`geo_location_id` )
    REFERENCES `expolab`.`geo_locations` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `expolab`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_sample_types1`
    FOREIGN KEY (`sample_type_id` )
    REFERENCES `expolab`.`sample_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`tests`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`tests` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`tests` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`split_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`split_types` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`split_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`sample_splits`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`sample_splits` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`sample_splits` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `id_code` VARCHAR(45) NOT NULL ,
  `sample_id` INT UNSIGNED NOT NULL ,
  `split_type_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_sample_splits_samples1` (`sample_id` ASC) ,
  INDEX `fk_sample_splits_split_types1` (`split_type_id` ASC) ,
  CONSTRAINT `fk_sample_splits_samples1`
    FOREIGN KEY (`sample_id` )
    REFERENCES `expolab`.`samples` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sample_splits_split_types1`
    FOREIGN KEY (`split_type_id` )
    REFERENCES `expolab`.`split_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`results`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `expolab`.`results` ;

CREATE  TABLE IF NOT EXISTS `expolab`.`results` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `value` FLOAT NOT NULL ,
  `timestamp` DATETIME NOT NULL ,
  `sample_split_id` INT UNSIGNED NOT NULL ,
  `technician_id` INT UNSIGNED NOT NULL ,
  `test_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_results_sample_splits1` (`sample_split_id` ASC) ,
  INDEX `fk_results_technicians1` (`technician_id` ASC) ,
  INDEX `fk_results_tests1` (`test_id` ASC) ,
  CONSTRAINT `fk_results_sample_splits1`
    FOREIGN KEY (`sample_split_id` )
    REFERENCES `expolab`.`sample_splits` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_results_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `expolab`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_results_tests1`
    FOREIGN KEY (`test_id` )
    REFERENCES `expolab`.`tests` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

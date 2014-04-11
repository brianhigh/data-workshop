SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `expolab` DEFAULT CHARACTER SET utf8 ;
USE `expolab` ;

-- -----------------------------------------------------
-- Table `expolab`.`buildings`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`buildings` (
  `id` INT NOT NULL AUTO_INCREMENT ,
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
-- Table `expolab`.`positions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`positions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`subjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`subjects` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `fname` VARCHAR(45) NOT NULL ,
  `lname` VARCHAR(45) NOT NULL ,
  `gender` ENUM('M','F') NULL ,
  `birthdate` DATE NULL ,
  `position_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_subjects_position1_idx` (`position_id` ASC) ,
  CONSTRAINT `fk_subjects_position1`
    FOREIGN KEY (`position_id` )
    REFERENCES `expolab`.`positions` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`body_locations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`body_locations` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`subject_locations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`subject_locations` (
  `id` INT NOT NULL ,
  `subject_id` INT NOT NULL ,
  `body_location_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_subject_location_subject1_idx` (`subject_id` ASC) ,
  INDEX `fk_subject_location_body_location1_idx` (`body_location_id` ASC) ,
  CONSTRAINT `fk_subject_location_subject1`
    FOREIGN KEY (`subject_id` )
    REFERENCES `expolab`.`subjects` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subject_location_body_location1`
    FOREIGN KEY (`body_location_id` )
    REFERENCES `expolab`.`body_locations` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`geo_locations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`geo_locations` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `desc` VARCHAR(45) NULL ,
  `lat` FLOAT NULL ,
  `lon` FLOAT NULL ,
  `building_id` INT NULL ,
  `floor` VARCHAR(45) NULL ,
  `room` VARCHAR(45) NULL ,
  `subject_location_id` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_location_building1_idx` (`building_id` ASC) ,
  INDEX `fk_geo_locations_subject_locations1_idx` (`subject_location_id` ASC) ,
  CONSTRAINT `fk_location_building1`
    FOREIGN KEY (`building_id` )
    REFERENCES `expolab`.`buildings` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_geo_locations_subject_locations1`
    FOREIGN KEY (`subject_location_id` )
    REFERENCES `expolab`.`subject_locations` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`sample_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`sample_types` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`technicians`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`technicians` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `fname` VARCHAR(45) NOT NULL ,
  `lname` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`samples`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`samples` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `sample_type_id` INT NOT NULL ,
  `geo_location_id` INT NOT NULL ,
  `technician_id` INT NOT NULL ,
  `temperature` FLOAT NULL ,
  `humidity` FLOAT NULL ,
  `comment` VARCHAR(45) NULL ,
  `id_code` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_sample_location1_idx` (`geo_location_id` ASC) ,
  INDEX `fk_sample_sample_type1_idx` (`sample_type_id` ASC) ,
  INDEX `fk_samples_technicians1_idx` (`technician_id` ASC) ,
  CONSTRAINT `fk_sample_location1`
    FOREIGN KEY (`geo_location_id` )
    REFERENCES `expolab`.`geo_locations` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sample_sample_type1`
    FOREIGN KEY (`sample_type_id` )
    REFERENCES `expolab`.`sample_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `expolab`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`tests`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`tests` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`split_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`split_types` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`sample_splits`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`sample_splits` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `sample_id` INT NOT NULL ,
  `split_types_id` INT NOT NULL ,
  `id_code` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_isolate_sample1_idx` (`sample_id` ASC) ,
  INDEX `fk_sample_splits_split_types1_idx` (`split_types_id` ASC) ,
  CONSTRAINT `fk_isolate_sample1`
    FOREIGN KEY (`sample_id` )
    REFERENCES `expolab`.`samples` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sample_splits_split_types1`
    FOREIGN KEY (`split_types_id` )
    REFERENCES `expolab`.`split_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expolab`.`results`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `expolab`.`results` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `test_id` INT NOT NULL ,
  `value` FLOAT NOT NULL ,
  `timestamp` DATETIME NOT NULL ,
  `technician_id` INT NOT NULL ,
  `sample_splits_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_result_test1_idx` (`test_id` ASC) ,
  INDEX `fk_results_sample_splits1_idx` (`sample_splits_id` ASC) ,
  INDEX `fk_results_technicians1_idx` (`technician_id` ASC) ,
  CONSTRAINT `fk_result_test1`
    FOREIGN KEY (`test_id` )
    REFERENCES `expolab`.`tests` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_results_sample_splits1`
    FOREIGN KEY (`sample_splits_id` )
    REFERENCES `expolab`.`sample_splits` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_results_technicians1`
    FOREIGN KEY (`technician_id` )
    REFERENCES `expolab`.`technicians` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

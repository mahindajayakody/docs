SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `erp` ;
CREATE SCHEMA IF NOT EXISTS `erp` DEFAULT CHARACTER SET utf8 ;
USE `erp` ;

-- -----------------------------------------------------
-- Table `erp`.`id_gen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`id_gen` ;

CREATE  TABLE IF NOT EXISTS `erp`.`id_gen` (
  `ID_NAME` VARCHAR(50) NOT NULL ,
  `ID_VALUE` INT(11) NULL DEFAULT '0' ,
  PRIMARY KEY (`ID_NAME`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`serial`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`serial` ;

CREATE  TABLE IF NOT EXISTS `erp`.`serial` (
  `SERIALID` INT(11) NOT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `FINAYEAR` INT(11) NULL DEFAULT NULL ,
  `FINABEGDATE` DATETIME NULL DEFAULT NULL ,
  `FINAENDDATE` DATETIME NULL DEFAULT NULL ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `RUNGNO` BIGINT(20) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`SERIALID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`serial_master`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`serial_master` ;

CREATE  TABLE IF NOT EXISTS `erp`.`serial_master` (
  `SERIALMASTERID` INT(11) NOT NULL ,
  `DESCRIPTION` VARCHAR(30) NULL DEFAULT NULL ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `ISBRANCH` SMALLINT(6) NULL DEFAULT NULL ,
  `ISPRD` SMALLINT(6) NULL DEFAULT NULL ,
  `ISANNUALLY` SMALLINT(6) NULL DEFAULT NULL ,
  PRIMARY KEY (`SERIALMASTERID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblaccwarehouse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblaccwarehouse` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblaccwarehouse` (
  `ACCBRNCHID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `BRANCHID` INT(10) UNSIGNED NOT NULL DEFAULT '0' ,
  `OFFICERID` INT(10) UNSIGNED NOT NULL DEFAULT '0' ,
  `BRNCHNAME` VARCHAR(45) NOT NULL DEFAULT '' ,
  `VERSIONID` INT(10) UNSIGNED NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`ACCBRNCHID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 683
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblaudittrial`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblaudittrial` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblaudittrial` (
  `COMID` INT(11) NULL DEFAULT NULL COMMENT 'Company Id' ,
  `BRANCHID` INT(11) NULL DEFAULT NULL COMMENT 'Branch Id' ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL COMMENT 'Product Id' ,
  `TRANNO` INT(40) NULL DEFAULT NULL COMMENT 'Transaction No' ,
  `TABLENAME` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Table Name' ,
  `PRIMARYKEY` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Primary Key' ,
  `AUDITDATA` VARCHAR(2000) NULL DEFAULT NULL COMMENT 'Audit Data' ,
  `ACTION` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Action Name' ,
  `TRANDATE` DATETIME NULL DEFAULT NULL COMMENT 'Transaction  Date' )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblwarehouse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblwarehouse` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblwarehouse` (
  `BRANCHID` INT(11) NOT NULL AUTO_INCREMENT ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `ADDLINE1` VARCHAR(40) NULL DEFAULT NULL ,
  `ADDLINE2` VARCHAR(40) NULL DEFAULT NULL ,
  `ADDLINE3` VARCHAR(40) NULL DEFAULT NULL ,
  `ADDLINE4` VARCHAR(40) NULL DEFAULT NULL ,
  `TPNO` VARCHAR(15) NULL DEFAULT NULL ,
  `FAXNO` VARCHAR(15) NULL DEFAULT NULL ,
  `TAXNO` VARCHAR(20) NULL DEFAULT NULL ,
  `ISDEFAULT` SMALLINT(6) NULL DEFAULT NULL ,
  `RCPACC` VARCHAR(20) NULL DEFAULT NULL ,
  `PMTACC` VARCHAR(20) NULL DEFAULT NULL ,
  `DATEINSTALL` DATETIME NULL DEFAULT NULL ,
  `FUNDAVAILABLE` DECIMAL(10,0) NULL DEFAULT NULL ,
  `FUNDLIMIT` DECIMAL(10,0) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `SYSDATE` INT(11) NULL DEFAULT NULL ,
  `BRANCHNAME` VARCHAR(50) NULL DEFAULT NULL ,
  `EMAIL` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`BRANCHID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblcancelduereceipt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblcancelduereceipt` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblcancelduereceipt` (
  `DUERCPID` INT(11) NOT NULL AUTO_INCREMENT ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL ,
  `TICKETID` INT(11) NULL DEFAULT NULL ,
  `RCPID` INT(11) NULL DEFAULT NULL ,
  `PAWNERID` INT(11) NULL DEFAULT NULL ,
  `SETAMOUNT` DECIMAL(18,2) NULL DEFAULT NULL ,
  `SETDATE` DATETIME NULL DEFAULT NULL ,
  `DUETYPEID` INT(11) NULL DEFAULT NULL ,
  `REFNO` INT(11) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `RECSTATUS` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`DUERCPID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblduereceipt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblduereceipt` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblduereceipt` (
  `DUERCPID` INT(11) NOT NULL AUTO_INCREMENT ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL ,
  `TICKETID` INT(11) NULL DEFAULT NULL ,
  `RCPID` INT(11) NULL DEFAULT NULL ,
  `PAWNERID` INT(11) NULL DEFAULT NULL ,
  `SETAMOUNT` DECIMAL(15,2) NULL DEFAULT NULL ,
  `SETDATE` DATETIME NULL DEFAULT NULL ,
  `DUETYPEID` INT(11) NULL DEFAULT NULL ,
  `REFNO` INT(11) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `RECSTATUS` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`DUERCPID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 9213
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tbleventlog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tbleventlog` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tbleventlog` (
  `EVENTLOGID` INT(11) NOT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL COMMENT 'Company Id' ,
  `BRANCHID` INT(11) NULL DEFAULT NULL COMMENT 'Branch Id' ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL COMMENT 'Product Id' ,
  `TRANNO` VARCHAR(40) NULL DEFAULT NULL COMMENT 'Transaction No' ,
  `PRGNAME` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Table Name' ,
  `EVENTID` INT(11) NULL DEFAULT NULL COMMENT 'Table Name' ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL COMMENT 'Transaction  Date' ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL COMMENT 'Last Updated User Id' ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL COMMENT 'Original Id' ,
  `RECSTATUS` INT(11) NULL DEFAULT NULL COMMENT 'Record Status' ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`EVENTLOGID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tbllocation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tbllocation` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tbllocation` (
  `LOCATIONID` INT(11) NOT NULL AUTO_INCREMENT ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `DESCRIPTION` VARCHAR(50) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`LOCATIONID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblmapcust`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblmapcust` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblmapcust` (
  `MAPPAWID` INT(11) NOT NULL ,
  `PWNID` INT(11) NULL DEFAULT NULL ,
  `PAWTYPEID` INT(11) NULL DEFAULT NULL ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `TEPAWID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`MAPPAWID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tbluser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tbluser` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tbluser` (
  `OFFICERID` INT(11) NOT NULL ,
  `DEFBRANCH` INT(11) NULL DEFAULT NULL ,
  `PWNID` INT(11) NULL DEFAULT NULL ,
  `USERNAME` VARCHAR(20) NULL DEFAULT NULL ,
  `PASSWORD` VARCHAR(50) NULL DEFAULT NULL ,
  `USERGROUP` INT(11) NULL DEFAULT NULL ,
  `ISACTIVE` SMALLINT(6) NULL DEFAULT NULL ,
  `VALIEDPD` INT(11) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`OFFICERID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblparameter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblparameter` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblparameter` (
  `PARAMETERID` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Parameter Id' ,
  `COMID` INT(11) NULL DEFAULT NULL COMMENT 'Company Id' ,
  `BRANCHID` INT(11) NULL DEFAULT NULL COMMENT 'Branch Id' ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL COMMENT 'Product Id' ,
  `CODE` VARCHAR(3) NULL DEFAULT NULL COMMENT 'Parameter Code' ,
  `DESCRIPTION` VARCHAR(60) NULL DEFAULT NULL COMMENT 'Product Description' ,
  `DATATYPE` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Data Type' ,
  `ISACTIVE` VARCHAR(1) NULL DEFAULT NULL COMMENT 'Is Active' ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL COMMENT 'Last Updated Date' ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Last Updated Time' ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL COMMENT 'Last Updated User Id' ,
  `RECSTATUS` VARCHAR(2) NULL DEFAULT NULL COMMENT 'Record Status' ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL COMMENT 'Original Record Id' ,
  `VERSIONID` INT(11) NULL DEFAULT NULL COMMENT 'Version' ,
  PRIMARY KEY (`PARAMETERID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblparametervalue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblparametervalue` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblparametervalue` (
  `PARAMETERVALUEID` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Parameter Value Id' ,
  `COMID` INT(11) NULL DEFAULT NULL COMMENT 'Company Id' ,
  `BRANCHID` INT(11) NULL DEFAULT NULL COMMENT 'Branch Id' ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL COMMENT 'Product Id' ,
  `PARAMETERID` INT(11) NULL DEFAULT NULL COMMENT 'Parameter Id' ,
  `PARAVALUE` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Parameter Value' ,
  `EFFDATE` DATETIME NULL DEFAULT NULL COMMENT 'Effective Date' ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL COMMENT 'Last Updated Date' ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Last Updated Time' ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL COMMENT 'Last Updated User Id' ,
  `RECSTATUS` VARCHAR(2) NULL DEFAULT NULL COMMENT 'Record Status' ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL COMMENT 'Original Record Id' ,
  `VERSIONID` INT(11) NULL DEFAULT NULL COMMENT 'Version' ,
  PRIMARY KEY (`PARAMETERVALUEID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblcustomer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblcustomer` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblcustomer` (
  `PWNID` INT(11) NOT NULL AUTO_INCREMENT ,
  `CORI` CHAR(1) NULL DEFAULT NULL ,
  `CLTITLE` VARCHAR(10) NULL DEFAULT NULL ,
  `INITIALS` VARCHAR(20) NULL DEFAULT NULL ,
  `INITIALSFULL` VARCHAR(150) NULL DEFAULT NULL ,
  `NAME` VARCHAR(100) NULL DEFAULT NULL ,
  `BRDATE` DATETIME NULL DEFAULT NULL ,
  `NATIONAL` VARCHAR(15) NULL DEFAULT NULL ,
  `MARISTS` SMALLINT(6) NULL DEFAULT NULL ,
  `IDNO` VARCHAR(20) NULL DEFAULT NULL ,
  `PPNO` VARCHAR(20) NULL DEFAULT NULL ,
  `DRVLNO` VARCHAR(20) NULL DEFAULT NULL ,
  `HOMETPNO` VARCHAR(15) NULL DEFAULT NULL ,
  `OFFICETPNO` VARCHAR(15) NULL DEFAULT NULL ,
  `MOBILENO` VARCHAR(15) NULL DEFAULT NULL ,
  `FAXNO` VARCHAR(15) NULL DEFAULT NULL ,
  `EMAIL` VARCHAR(60) NULL DEFAULT NULL ,
  `MAILADDLINE1` VARCHAR(60) NULL DEFAULT NULL ,
  `MAILADDLINE2` VARCHAR(60) NULL DEFAULT NULL ,
  `MAILADDLINE3` VARCHAR(60) NULL DEFAULT NULL ,
  `MAILADDLINE4` VARCHAR(60) NULL DEFAULT NULL ,
  `INTDTE` DATETIME NULL DEFAULT NULL ,
  `CLSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `SEX` SMALLINT(6) NULL DEFAULT NULL ,
  `pawnCODE` VARCHAR(10) NULL DEFAULT NULL ,
  PRIMARY KEY (`PWNID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 1778
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblcusttype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblcusttype` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblcusttype` (
  `PWTID` INT(11) NOT NULL AUTO_INCREMENT ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `DESCRIPTION` VARCHAR(60) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`PWTID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblprgaccess`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblprgaccess` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblprgaccess` (
  `PRGACCESSID` INT(11) NOT NULL AUTO_INCREMENT ,
  `ACCESS` VARCHAR(10) NULL DEFAULT NULL ,
  `PRGID` INT(11) NULL DEFAULT NULL ,
  `USERGROUPID` INT(11) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`PRGACCESSID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 1373
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblproduct`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblproduct` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblproduct` (
  `PRODUCTID` INT(11) NOT NULL AUTO_INCREMENT ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `DESCRIPTION` VARCHAR(50) NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `SCHEMEID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`PRODUCTID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblreceipt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblreceipt` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblreceipt` (
  `RCPID` INT(11) NOT NULL AUTO_INCREMENT ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `PRODUCTID` INT(11) NULL DEFAULT NULL ,
  `TICKETID` INT(11) NULL DEFAULT NULL ,
  `RCPNO` VARCHAR(12) NULL DEFAULT NULL ,
  `pawnERID` INT(11) NULL DEFAULT NULL ,
  `DESCRIPTION` VARCHAR(200) NULL DEFAULT NULL ,
  `RCPAMOUNT` DECIMAL(18,2) NULL DEFAULT NULL ,
  `RCPDATE` DATETIME NULL DEFAULT NULL ,
  `RCPTYPE` SMALLINT(5) UNSIGNED NULL DEFAULT NULL ,
  `PRINTNO` INT(11) NULL DEFAULT NULL ,
  `PRINTDATE` DATETIME NULL DEFAULT NULL ,
  `CHEQUENO` VARCHAR(20) NULL DEFAULT NULL ,
  `CHEQUEDATE` DATETIME NULL DEFAULT NULL ,
  `STATUS` INT(11) NULL DEFAULT NULL ,
  `LASTUPDATE` VARCHAR(45) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `ORIGINALID` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `LASTUPUSERID` VARCHAR(25) NULL DEFAULT NULL ,
  `RPCENTUSER` VARCHAR(20) NULL DEFAULT NULL ,
  `CANCELUSERID` INT(11) NULL DEFAULT NULL ,
  `CANCELDATE` DATETIME NULL DEFAULT NULL ,
  `RECSTATUS` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`RCPID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 4296
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblsystemdate`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblsystemdate` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblsystemdate` (
  `SYSDATEID` INT(11) NOT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL ,
  `BRANCHID` INT(11) NULL DEFAULT NULL ,
  `PRVDATE` DATETIME NULL DEFAULT NULL ,
  `CURDATE` DATETIME NULL DEFAULT NULL ,
  `NXTDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`SYSDATEID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblsystemprogram`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblsystemprogram` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblsystemprogram` (
  `PRGID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `PRDCODE` CHAR(2) NULL DEFAULT NULL ,
  `PARENTID` SMALLINT(6) NULL DEFAULT NULL ,
  `NODENAME` VARCHAR(30) NULL DEFAULT NULL ,
  `URLPATH` VARCHAR(30) NULL DEFAULT NULL ,
  `ACCESS` VARCHAR(15) NULL DEFAULT '1:2:3' ,
  PRIMARY KEY (`PRGID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblusercompany`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblusercompany` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblusercompany` (
  `COMID` INT(11) NOT NULL AUTO_INCREMENT ,
  `CODE` CHAR(3) NULL DEFAULT NULL ,
  `COMPNAME` VARCHAR(50) NULL DEFAULT NULL ,
  `ADDLINE1` VARCHAR(40) NULL DEFAULT NULL ,
  `ADDLINE2` VARCHAR(40) NULL DEFAULT NULL ,
  `ADDLINE3` VARCHAR(40) NULL DEFAULT NULL ,
  `ADDLINE4` VARCHAR(40) NULL DEFAULT NULL ,
  `TPNO` VARCHAR(15) NULL DEFAULT NULL ,
  `FAXNO` VARCHAR(15) NULL DEFAULT NULL ,
  `TAXNO` VARCHAR(20) NULL DEFAULT NULL ,
  `DATEINSTALL` DATETIME NULL DEFAULT NULL ,
  `FBIGDATE` DATETIME NULL DEFAULT NULL ,
  `FENDDATE` DATETIME NULL DEFAULT NULL ,
  `RECSTATUS` SMALLINT(6) NULL DEFAULT NULL ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL ,
  `LASTUPTIME` MEDIUMTEXT NULL DEFAULT NULL ,
  `LASTUPUSERID` INT(11) NULL DEFAULT NULL ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `AUTHMODE` SMALLINT(6) NULL DEFAULT NULL ,
  PRIMARY KEY (`COMID`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tbluserlog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tbluserlog` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tbluserlog` (
  `USERLOGID` INT(11) NOT NULL ,
  `COMID` INT(11) NULL DEFAULT NULL COMMENT 'Company Id' ,
  `BRANCHID` INT(11) NULL DEFAULT NULL COMMENT 'Branch Id' ,
  `TRANNO` VARCHAR(40) NULL DEFAULT NULL COMMENT 'Transaction No' ,
  `STATUS` INT(1) NULL DEFAULT NULL COMMENT 'Status' ,
  `LASTUPDATE` DATETIME NULL DEFAULT NULL COMMENT 'Transaction  Date' ,
  `LASTUPUSERID` INT(1) NULL DEFAULT NULL COMMENT ' User Id' ,
  `ORIGINALID` INT(11) NULL DEFAULT NULL ,
  `VERSIONID` INT(11) NULL DEFAULT NULL ,
  `RECSTATUS` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`USERLOGID`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `erp`.`tblitemaster`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblitemaster` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblitemaster` (
  `itemmasterid` INT NOT NULL ,
  `description` VARCHAR(100) NOT NULL ,
  `rol` INT NOT NULL ,
  PRIMARY KEY (`itemmasterid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblitemcat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblitemcat` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblitemcat` (
  `itemcatid` INT NOT NULL ,
  `code` VARCHAR(5) NOT NULL ,
  `description` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`itemcatid`) ,
  UNIQUE INDEX `code_UNIQUE` (`code` ASC) )
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `erp`.`tblpurchaseorder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblpurchaseorder` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblpurchaseorder` (
  `purchaseorderid` INT NOT NULL ,
  PRIMARY KEY (`purchaseorderid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblpodetail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblpodetail` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblpodetail` (
  `podetailid` INT NOT NULL ,
  PRIMARY KEY (`podetailid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblgrn`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblgrn` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblgrn` (
  `tblgrnid` INT NOT NULL ,
  PRIMARY KEY (`tblgrnid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblgrndetail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblgrndetail` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblgrndetail` (
  `grndetailid` INT NOT NULL ,
  PRIMARY KEY (`grndetailid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblbill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblbill` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblbill` (
  `billid` INT NOT NULL ,
  PRIMARY KEY (`billid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblbilldetail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblbilldetail` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblbilldetail` (
  `billdetailid` INT NOT NULL ,
  PRIMARY KEY (`billdetailid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `erp`.`tblemployee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `erp`.`tblemployee` ;

CREATE  TABLE IF NOT EXISTS `erp`.`tblemployee` (
  `employeeid` INT NOT NULL ,
  `parentid` INT NULL ,
  `name` VARCHAR(60) NULL ,
  `designation` VARCHAR(45) NULL ,
  PRIMARY KEY (`employeeid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- procedure test_proc3
-- -----------------------------------------------------

USE `erp`;
DROP procedure IF EXISTS `erp`.`test_proc3`;

DELIMITER $$
USE `erp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `test_proc3`()
begin
DECLARE  dueAmount double;
DECLARE  paidAmount double;
DECLARE  receiptAmount double;
DECLARE  ticketNo  varchar(20);
DECLARE  receiptId  int;

set dueAmount = 313;
set paidAmount = 313;
set ticketNo ='TR1PW11000129';
set receiptAmount = 0.0;


update pawn_pmb.tblduefrom set dueamount = dueAmount, paidamount = 0,balamount= dueAmount where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;
update pawn_pmb.tblduereceipt set setamount= paidAmount where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;

select  sum(setamount) into receiptAmount from pawn_pmb.tblduereceipt where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo);
select  rcpid into receiptId from pawn_pmb.tblduereceipt where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;

update pawn_pmb.tblreceipt set rcpamount = receiptAmount where rcpid = receiptId ;


select * from pawn_pmb.tblduefrom where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;
select * from pawn_pmb.tblduereceipt where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;
select * from pawn_pmb.tblreceipt where rcpid = receiptId ; 

END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

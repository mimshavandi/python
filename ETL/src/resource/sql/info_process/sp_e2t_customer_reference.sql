DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_e2t_customer_reference;
CREATE PROCEDURE info_process.sp_e2t_customer_reference(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_e2t_customer_reference";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for non natural person from source files and QC table";


DROP TABLE IF EXISTS non_natural_person_tmp;
CREATE TEMPORARY TABLE  non_natural_person_tmp 
SELECT 
report_date 	   			AS reporting_reference_date,
national_id_number			AS party_identifier,
FullName					AS registered_name,
RESIDENCE					AS registered_place,
NATIONALITY					AS registered_country,
legal_capacity				AS legal_capacity,
""							AS enterprise_size,
CUSTOMER_ID					AS internal_id,
"customer_01_reference"		AS source
FROM info_extract.customer_reference_01_e
WHERE 	type_of_person = "non_natural_person"
AND 	report_date = p_date
GROUP BY 1,2,3,4,5,6,7,8,9

UNION

SELECT 
report_date 	   								AS reporting_reference_date,
tax_pay_id										AS party_identifier,
name_1											AS registered_name,
residence										AS registered_place,
nationality										AS registered_country,
CASE WHEN legal_form = 7 THEN "N" ELSE "Y" END	AS legal_capacity,
""												AS enterprise_size,
CUSTOMER_ID										AS internal_id,
"customer_03_reference"							AS source
FROM info_extract.customer_reference_03_e
WHERE 	type_of_person = "non_natural_person"
AND 	report_date = p_date
GROUP BY 1,2,3,4,5,6,7,8,9

UNION

SELECT 
reporting_reference_date, party_identifier, registered_name, registered_place,
registered_country, legal_capacity, enterprise_size, internal_id, source
FROM info_qc.non_natural_person_qc
WHERE 	reporting_reference_date = p_date
AND 	action = "G"
AND 	status IS NULL
;

	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;


	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "02";
	SET step_desc = "Set the status flag for natural person QC table to Done";
	
UPDATE 	info_qc.non_natural_person_qc
SET status = "Done"
WHERE	reporting_reference_date = p_date
AND 	action = "GO"
AND 	status IS NULL
;
	
	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;


	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "03";
	SET step_desc = "Create temporary table for natural person from source files and QC table";	
	

DROP TABLE IF EXISTS natural_person_tmp;
CREATE TEMPORARY TABLE  natural_person_tmp 
SELECT 
report_date 	   			AS reporting_reference_date,
national_id_number			AS party_identifier,
NATIONALITY					AS nationality,
Initials					AS initials,
FIRSTNAME					AS birthname,
""							AS affix_birth_name,
LASTNAME					AS last_name,
""							AS affix_last_name,
party_birth_date			AS date_of_birth,
NULL						AS gender,
""							AS vital_status,
CUSTOMER_ID					AS internal_id,
"customer_01_reference"		AS source
FROM info_extract.customer_reference_01_e
WHERE type_of_person = "natural_person"
AND report_date = p_date
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
BSNNumber					AS party_identifier,
Nationality					AS nationality,
Initials					AS initials,
FirstName					AS birthname,
""							AS affix_birth_name,
LastName					AS last_name,
""							AS affix_last_name,
Birthday					AS date_of_birth,
CASE WHEN Gender = "Male" THEN "M" ELSE CASE WHEN Gender = "Female" THEN "F" ELSE NULL END END AS gender,
""							AS vital_status,
CUSTOMER_ID					AS internal_id,
"customer_02_reference"		AS source
FROM info_extract.customer_reference_02_e
WHERE report_date = p_date
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
tax_pay_id					AS party_identifier,
nationality					AS nationality,
title						AS initials,
given_names					AS birthname,
""							AS affix_birth_name,
family_name					AS last_name,
IFNULL(affix,'')			AS affix_last_name,
birth_date					AS date_of_birth,
CASE WHEN title = "HERR" THEN "M" ELSE CASE WHEN title = "FRAU" THEN "F" ELSE NULL END END AS gender,
""							AS vital_status,
CUSTOMER_ID					AS internal_id,
"customer_03_reference"		AS source
FROM info_extract.customer_reference_03_e
WHERE type_of_person = "natural_person"
AND report_date = p_date
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

UNION 

SELECT 
reporting_reference_date, party_identifier, nationality, initials,
birthname, affix_birth_name, last_name, affix_last_name, date_of_birth,
gender, vital_status, internal_id, source
FROM info_qc.natural_person_qc
WHERE 	reporting_reference_date = p_date
AND 	action = "G"
AND 	status IS NULL
;

	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;


	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "04";
	SET step_desc = "Set the status flag for natural person QC table to Done";
	
UPDATE 	info_qc.natural_person_qc
SET status = "Done"
WHERE	reporting_reference_date = p_date
AND 	action = "GO"
AND 	status IS NULL
;
	
	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "05";
	SET step_desc = "Separate clean and non clean data for non natural person; Making scd hash for clean data";
	
DROP TABLE IF EXISTS non_natural_person_clean_tmp;
CREATE TEMPORARY TABLE  non_natural_person_clean_tmp 
SELECT *, 
MD5(CONCAT(registered_name,registered_place,registered_country,legal_capacity,enterprise_size)) AS scd_hash
FROM non_natural_person_tmp
WHERE 	reporting_reference_date IS NOT NULL
AND 	party_identifier IS NOT NULL
AND		registered_name IS NOT NULL
AND		registered_place IS NOT NULL
AND		registered_country IS NOT NULL
AND		legal_capacity IS NOT NULL
AND		internal_id IS NOT NULL
;


DROP TABLE IF EXISTS non_natural_person_non_clean_tmp;
CREATE TEMPORARY TABLE  non_natural_person_non_clean_tmp 
SELECT * FROM non_natural_person_tmp
WHERE 	reporting_reference_date IS NULL
OR	 	party_identifier IS NULL
OR		registered_name IS NULL
OR		registered_place IS NULL
OR		registered_country IS NULL
OR		legal_capacity IS NULL
OR		internal_id IS NULL
;
	
	
	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "06";
	SET step_desc = "Separate clean and non clean data for natural person; Making scd hash for clean data";
	

DROP TABLE IF EXISTS natural_person_clean_tmp;
CREATE TEMPORARY TABLE  natural_person_clean_tmp 
SELECT *, 
MD5(CONCAT(nationality, initials, birthname, affix_birth_name,
last_name, affix_last_name, date_of_birth, gender, vital_status)) AS scd_hash
FROM natural_person_tmp
WHERE 	reporting_reference_date IS NOT NULL
AND 	party_identifier IS NOT NULL
AND 	nationality IS NOT NULL
AND 	initials IS NOT NULL
AND 	birthname IS NOT NULL
AND 	last_name IS NOT NULL
AND 	date_of_birth IS NOT NULL
AND 	gender IS NOT NULL
AND 	internal_id IS NOT NULL
;


DROP TABLE IF EXISTS natural_person_non_clean_tmp;
CREATE TEMPORARY TABLE  natural_person_non_clean_tmp 
SELECT * FROM natural_person_tmp
WHERE 	reporting_reference_date IS NULL
OR 		party_identifier IS NULL
OR 		nationality IS NULL
OR 		initials IS NULL
OR 		birthname IS NULL
OR 		last_name IS NULL
OR 		date_of_birth IS NULL
OR 		gender IS NULL
OR 		internal_id IS NULL
;

	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "07";
	SET step_desc = "Load data to transform table for non natural person";
	
		
INSERT INTO info_transform.non_natural_person_t 
(party_identifier, registered_name, registered_place, registered_country,
legal_capacity, enterprise_size, internal_id, source, scd_hash, reporting_reference_date)
SELECT
party_identifier, GROUP_CONCAT(DISTINCT registered_name SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT registered_place SEPARATOR ";"), GROUP_CONCAT(DISTINCT registered_country SEPARATOR ";"),
GROUP_CONCAT(DISTINCT legal_capacity SEPARATOR ";"), GROUP_CONCAT(DISTINCT enterprise_size SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT internal_id SEPARATOR ";"), GROUP_CONCAT(DISTINCT source SEPARATOR ";"), 
MD5(GROUP_CONCAT(DISTINCT scd_hash SEPARATOR ";")), GROUP_CONCAT(DISTINCT reporting_reference_date SEPARATOR ";")
FROM non_natural_person_clean_tmp
GROUP BY 1
;

	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	

	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "08";
	SET step_desc = "Load data to QC table for non natural person";

INSERT INTO info_qc.non_natural_person_qc
(reporting_reference_date, party_identifier, registered_name, registered_place,
registered_country, legal_capacity, enterprise_size, internal_id, source)
SELECT
reporting_reference_date, party_identifier, registered_name, registered_place,
registered_country, legal_capacity, enterprise_size, internal_id, source
FROM non_natural_person_non_clean_tmp
;
	
	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;		
	

	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "09";
	SET step_desc = "Load data to transform table for natural person";
	
INSERT INTO info_transform.natural_person_t 
(party_identifier, nationality, initials, birthname, affix_birth_name, last_name, 
affix_last_name, date_of_birth, gender, vital_status, internal_id, source, scd_hash, reporting_reference_date)
SELECT
party_identifier, GROUP_CONCAT(DISTINCT nationality SEPARATOR ';'), 
GROUP_CONCAT(DISTINCT initials SEPARATOR ';'), GROUP_CONCAT(DISTINCT birthname SEPARATOR ';'), 
GROUP_CONCAT(DISTINCT affix_birth_name SEPARATOR ';'), GROUP_CONCAT(DISTINCT last_name SEPARATOR ';'), 
GROUP_CONCAT(DISTINCT affix_last_name SEPARATOR ';'), GROUP_CONCAT(DISTINCT date_of_birth SEPARATOR ';'), 
GROUP_CONCAT(DISTINCT gender SEPARATOR ';'), GROUP_CONCAT(DISTINCT vital_status SEPARATOR ';'), 
GROUP_CONCAT(DISTINCT internal_id SEPARATOR ';'), GROUP_CONCAT(DISTINCT source SEPARATOR ';'), 
MD5(GROUP_CONCAT(DISTINCT scd_hash SEPARATOR ';')), GROUP_CONCAT(DISTINCT reporting_reference_date SEPARATOR ';')
FROM natural_person_clean_tmp
GROUP BY 1
;

	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "10";
	SET step_desc = "Load data to QC table for natural person";
	
INSERT INTO info_qc.natural_person_qc
(reporting_reference_date, party_identifier, nationality, initials,
birthname, affix_birth_name, last_name, affix_last_name, date_of_birth,
gender, vital_status, internal_id, source)
SELECT
reporting_reference_date, party_identifier, nationality, initials,
birthname, affix_birth_name, last_name, affix_last_name, date_of_birth,
gender, vital_status, internal_id, source
FROM natural_person_non_clean_tmp
;
	
	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	
		
END$$

DELIMITER ;



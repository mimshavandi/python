DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_p2r_non_natural_person;
CREATE PROCEDURE info_process.sp_p2r_non_natural_person(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_p2r_non_natural_person";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for non_natural_person from production data.";
	
TRUNCATE TABLE 	info_report.non_natural_person;

DROP TABLE IF EXISTS non_natural_person_prod_tmp;
CREATE TEMPORARY TABLE  non_natural_person_prod_tmp 
SELECT 
"DBA4" AS bank_identifier,
p_date AS reporting_reference_date,
party_identifier, 
registered_name,
registered_place,
registered_country,
legal_capacity,
enterprise_size
FROM info_core.non_natural_person 
WHERE 
p_date BETWEEN dw_val_date AND dw_exp_date

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
	SET step_desc = "Insert data into report table.";
	
INSERT INTO info_report.non_natural_person
(bank_identifier, reporting_reference_date, party_identifier, registered_name, 
registered_place, registered_country, legal_capacity, enterprise_size)
SELECT * 
FROM non_natural_person_prod_tmp
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
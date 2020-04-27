DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_p2r_party;
CREATE PROCEDURE info_process.sp_p2r_party(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_p2r_party";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for party from production data.";
	
TRUNCATE TABLE 	info_report.party;
	
DROP TABLE IF EXISTS party_prod_tmp;
CREATE TEMPORARY TABLE  party_prod_tmp 
SELECT 
"DBA4" AS bank_identifier,
p_date AS reporting_reference_date,
party_identifier, 
type_of_party,
identifier_indicator,
telephone_number,
mobile_number,
email_address
FROM info_core.party
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
	
INSERT INTO info_report.party
(bank_identifier, reporting_reference_date, party_identifier, type_of_party, 
identifier_indicator, telephone_number, mobile_number, email_address)
SELECT * 
FROM party_prod_tmp
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
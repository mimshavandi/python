DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_p2r_bank_account_ownership;
CREATE PROCEDURE info_process.sp_p2r_bank_account_ownership(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_p2r_bank_account_ownership";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for ownership from bank account and party role production data.";


TRUNCATE TABLE 	info_report.bank_account_ownership;


DROP TABLE IF EXISTS bank_account_ownership_prod_tmp;
CREATE TEMPORARY TABLE  bank_account_ownership_prod_tmp 
SELECT 
"DBA4" AS bank_identifier,
p_date AS reporting_reference_date,
a.party_identifier, 
a.party_role, 
b.bank_account_identifier, 
NULL AS participation_percentage
FROM info_core.party_role a
JOIN info_core.bank_account b ON a.internal_id = b.internal_id
WHERE 
p_date BETWEEN a.dw_val_date AND a.dw_exp_date
AND
p_date BETWEEN b.dw_val_date AND b.dw_exp_date
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
	
INSERT INTO info_report.bank_account_ownership
(bank_identifier, reporting_reference_date, party_identifier,
role_of_party, bank_account_identifier, participation_percentage)
SELECT * 
FROM bank_account_ownership_prod_tmp
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
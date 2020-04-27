DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_e2t_bank_account;
CREATE PROCEDURE info_process.sp_e2t_bank_account (IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_e2t_bank_account";
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for bank account from source file and QC table";
	

DROP TABLE IF EXISTS bank_account_tmp;
CREATE TEMPORARY TABLE  bank_account_tmp 
SELECT 
report_date 	   				AS reporting_reference_date,
bank_account_identifier			AS bank_account_identifier,
type_of_bank_account			AS type_of_bank_account,
""								AS type_of_third_party_account,
eligible_account				AS eligible_account,
bank_account_number				AS bank_account_number,
""								AS ascription,
account_label					AS account_label,
currency						AS currency,
balance							AS balance,
interest						AS interest,
blocked_account_indicator		AS blocked_account_indicator,
country_of_branch_of_account	AS country_of_branch_of_account,
1								AS count_of_depositors,
CUSTOMER_ID						AS internal_id,
"product"						AS source
FROM info_extract.product_e
WHERE report_date = p_date
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

UNION 

SELECT 
reporting_reference_date, bank_account_identifier, type_of_bank_account, type_of_third_party_account,
eligible_account, bank_account_number, ascription, account_label, currency, balance, interest,
blocked_account_indicator, country_of_branch_of_account, count_of_depositors, internal_id, source
FROM info_qc.bank_account_qc
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
	SET step_desc = "Set the status flag for bank account QC table to Done";
	
UPDATE 	info_qc.bank_account_qc
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
	SET step_desc = "Separate clean and non clean data for bank account; Making scd hash for clean data";
	
DROP TABLE IF EXISTS bank_account_clean_tmp;
CREATE TEMPORARY TABLE  bank_account_clean_tmp 
SELECT *, 
MD5(CONCAT(type_of_bank_account, type_of_third_party_account, eligible_account,
bank_account_number, ascription, account_label, currency, balance, interest,
blocked_account_indicator, country_of_branch_of_account, count_of_depositors)) AS scd_hash
FROM bank_account_tmp
WHERE 	reporting_reference_date IS NOT NULL
AND 	bank_account_identifier IS NOT NULL
AND		type_of_bank_account IS NOT NULL
AND		eligible_account IS NOT NULL
AND		bank_account_number IS NOT NULL
AND		account_label IS NOT NULL
AND		currency IS NOT NULL
AND		balance IS NOT NULL
AND		interest IS NOT NULL
AND		blocked_account_indicator IS NOT NULL
AND		country_of_branch_of_account IS NOT NULL
AND		count_of_depositors IS NOT NULL
AND		internal_id IS NOT NULL
;


DROP TABLE IF EXISTS bank_account_non_clean_tmp;
CREATE TEMPORARY TABLE  bank_account_non_clean_tmp 
SELECT * FROM bank_account_tmp
WHERE 	reporting_reference_date IS NULL
OR 		bank_account_identifier IS NULL
OR		type_of_bank_account IS NULL
OR		eligible_account IS NULL
OR		bank_account_number IS NULL
OR		account_label IS NULL
OR		currency IS NULL
OR		balance IS NULL
OR		interest IS NULL
OR		blocked_account_indicator IS NULL
OR		country_of_branch_of_account IS NULL
OR		count_of_depositors IS NULL
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
	SET step_number = "04";
	SET step_desc = "Load data to transform table.";


INSERT INTO info_transform.bank_account_t 
(bank_account_identifier, type_of_bank_account,
type_of_third_party_account, eligible_account, bank_account_number, ascription,
account_label, currency, balance, interest, blocked_account_indicator,
country_of_branch_of_account, count_of_depositors, internal_id, source,
scd_hash, reporting_reference_date)
SELECT 
bank_account_identifier, GROUP_CONCAT(DISTINCT type_of_bank_account SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT type_of_third_party_account SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT eligible_account SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT bank_account_number SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT ascription SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT account_label SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT currency SEPARATOR ";"), 
SUM(balance),
SUM(interest), 
GROUP_CONCAT(DISTINCT blocked_account_indicator SEPARATOR ";"),
GROUP_CONCAT(DISTINCT country_of_branch_of_account SEPARATOR ";"),
SUM(count_of_depositors),
GROUP_CONCAT(DISTINCT internal_id SEPARATOR ";"), GROUP_CONCAT(DISTINCT source SEPARATOR ";"), 
MD5(GROUP_CONCAT(DISTINCT scd_hash SEPARATOR ";")), GROUP_CONCAT(DISTINCT reporting_reference_date SEPARATOR ";")
FROM bank_account_clean_tmp
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
	SET step_number = "05";
	SET step_desc = "Load data to QC table.";

INSERT INTO info_qc.bank_account_qc
(reporting_reference_date, bank_account_identifier, type_of_bank_account,
type_of_third_party_account, eligible_account, bank_account_number, ascription,
account_label, currency, balance, interest, blocked_account_indicator,
country_of_branch_of_account, count_of_depositors, internal_id, source)
SELECT
reporting_reference_date, bank_account_identifier, type_of_bank_account,
type_of_third_party_account, eligible_account, bank_account_number, ascription,
account_label, currency, balance, interest, blocked_account_indicator,
country_of_branch_of_account, count_of_depositors, internal_id, source
FROM bank_account_non_clean_tmp
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



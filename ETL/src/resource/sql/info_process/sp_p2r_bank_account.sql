DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_p2r_bank_account;
CREATE PROCEDURE info_process.sp_p2r_bank_account(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_p2r_bank_account";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for bank account from production data.";

TRUNCATE TABLE 	info_report.bank_account;
	
DROP TABLE IF EXISTS bank_account_prod_tmp;
CREATE TEMPORARY TABLE  bank_account_prod_tmp 
SELECT 
"DBA4" AS bank_identifier,
p_date AS reporting_reference_date,
bank_account_identifier,				
type_of_bank_account,				
type_of_third_party_account,			
eligible_account,					
bank_account_number,							
ascription,									
account_label,								
currency,										
balance,								
interest,										
CASE WHEN blocked_account_indicator = "non_blocked_bank_account" THEN 0 ELSE 1 END AS blocked_account_indicator,			
country_of_branch_of_account,		
count_of_depositors
FROM info_core.bank_account 
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
	
INSERT INTO info_report.bank_account
(bank_identifier, reporting_reference_date, bank_account_identifier, type_of_bank_account, 
type_of_third_party_account, eligible_account, bank_account_number,ascription, account_label,	
currency, balance, interest, blocked_account_indicator, country_of_branch_of_account, count_of_depositors)
SELECT * 
FROM bank_account_prod_tmp
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
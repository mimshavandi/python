DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_t2p_bank_account;
CREATE PROCEDURE info_process.sp_t2p_bank_account(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_t2p_bank_account";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for bank account from current production data.";
	
DROP TABLE IF EXISTS bank_account_prod_tmp;
CREATE TEMPORARY TABLE  bank_account_prod_tmp 
SELECT 
id, bank_account_identifier, scd_hash
FROM info_core.bank_account
WHERE dw_curr_in
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
	SET step_desc = "Create temporary table for bank account from transform tables.";
	
DROP TABLE IF EXISTS bank_account_transform_tmp;
CREATE TEMPORARY TABLE  bank_account_transform_tmp 
SELECT 
id, bank_account_identifier, scd_hash
FROM info_transform.bank_account_t
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
	SET step_desc = "Coparison between production and transform tables - Find out the duplicate data.";
	
DROP TABLE IF EXISTS bank_account_duplicated_tmp;
CREATE TEMPORARY TABLE  bank_account_duplicated_tmp 
SELECT b.id
FROM bank_account_prod_tmp a
JOIN bank_account_transform_tmp b
ON 		a.bank_account_identifier = b.bank_account_identifier
AND 	a.scd_hash = b.scd_hash
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
	SET step_desc = "Coparison between production and transform tables - Find out the changed data.";
	
DROP TABLE IF EXISTS bank_account_changed_tmp;
CREATE TEMPORARY TABLE  bank_account_changed_tmp 
SELECT a.id AS prod_id, b.id AS transform_id
FROM bank_account_prod_tmp a
JOIN bank_account_transform_tmp b
ON 		a.bank_account_identifier = b.bank_account_identifier
WHERE 	a.scd_hash <> b.scd_hash
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
	SET step_desc = "Coparison between production and transform tables - Find out the new data.";
	

DROP TABLE IF EXISTS bank_account_new_tmp;
CREATE TEMPORARY TABLE  bank_account_new_tmp 
SELECT id AS transform_id
FROM bank_account_transform_tmp
WHERE 
bank_account_identifier NOT IN (
SELECT bank_account_identifier FROM
bank_account_prod_tmp)
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
	SET step_desc = "Set the action flags for duplicates, changes and adds in the transform tables.";

-- Duplicates	
UPDATE info_transform.bank_account_t
SET action = "D",
	status = "X"
WHERE id IN (
SELECT * FROM bank_account_duplicated_tmp)
;
	
-- Changes
UPDATE info_transform.bank_account_t
SET action = "C"
WHERE id IN (
SELECT transform_id FROM bank_account_changed_tmp)
;

-- Adds
UPDATE info_transform.bank_account_t
SET action = "A"
WHERE id IN (
SELECT transform_id FROM bank_account_new_tmp)
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
	SET step_desc = "Insert the new data into production; Set the result flag in transform and scd columns in production.";
	
INSERT INTO info_core.bank_account
(bank_account_identifier, dw_curr_in, dw_val_date, dw_exp_date,
type_of_bank_account, type_of_third_party_account, eligible_account, 
bank_account_number, ascription, account_label, currency, balance, interest, 
blocked_account_indicator, country_of_branch_of_account, count_of_depositors,
internal_id, source, scd_hash, reporting_reference_date)
SELECT
bank_account_identifier, 1 , p_date , 99991231 ,
type_of_bank_account, type_of_third_party_account, eligible_account, 
bank_account_number, ascription, account_label, currency, balance, interest, 
blocked_account_indicator, country_of_branch_of_account, count_of_depositors,
internal_id, source, scd_hash, reporting_reference_date
FROM info_transform.bank_account_t
WHERE action = "A"
;


UPDATE info_transform.bank_account_t
SET status = "D"
WHERE action = "A"
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
	SET step_desc = "Insert the changed data into production; Set the result flag in transform and scd columns in production.";
	
INSERT INTO info_core.bank_account
(bank_account_identifier, dw_curr_in, dw_val_date, dw_exp_date,
type_of_bank_account, type_of_third_party_account, eligible_account, 
bank_account_number, ascription, account_label, currency, balance, interest, 
blocked_account_indicator, country_of_branch_of_account, count_of_depositors,
internal_id, source, scd_hash, reporting_reference_date)
SELECT
bank_account_identifier, 1 , p_date , 99991231 ,
type_of_bank_account, type_of_third_party_account, eligible_account, 
bank_account_number, ascription, account_label, currency, balance, interest, 
blocked_account_indicator, country_of_branch_of_account, count_of_depositors,
internal_id, source, scd_hash, reporting_reference_date
FROM info_transform.bank_account_t
WHERE action = "C"
;


UPDATE info_core.bank_account
SET dw_curr_in = 0,
	dw_exp_date = p_date
WHERE id IN (
SELECT prod_id FROM bank_account_changed_tmp)
;
	
	
UPDATE info_transform.bank_account_t
SET status = "D"
WHERE action = "C"
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
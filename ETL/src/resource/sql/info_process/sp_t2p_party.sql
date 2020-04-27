DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_t2p_party;
CREATE PROCEDURE info_process.sp_t2p_party(IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_t2p_party";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for party from current production data.";
	
DROP TABLE IF EXISTS party_prod_tmp;
CREATE TEMPORARY TABLE  party_prod_tmp 
SELECT 
id, party_identifier, scd_hash
FROM info_core.party
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
	SET step_desc = "Create temporary table for party from transform tables.";
	
DROP TABLE IF EXISTS party_transform_tmp;
CREATE TEMPORARY TABLE  party_transform_tmp 
SELECT 
id, party_identifier, scd_hash
FROM info_transform.party_t
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
	
DROP TABLE IF EXISTS party_duplicated_tmp;
CREATE TEMPORARY TABLE  party_duplicated_tmp 
SELECT b.id
FROM party_prod_tmp a
JOIN party_transform_tmp b
ON 		a.party_identifier = b.party_identifier
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
	
DROP TABLE IF EXISTS party_changed_tmp;
CREATE TEMPORARY TABLE  party_changed_tmp 
SELECT a.id AS prod_id, b.id AS transform_id
FROM party_prod_tmp a
JOIN party_transform_tmp b
ON 		a.party_identifier = b.party_identifier
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
	

DROP TABLE IF EXISTS party_new_tmp;
CREATE TEMPORARY TABLE  party_new_tmp 
SELECT id AS transform_id
FROM party_transform_tmp
WHERE 
party_identifier NOT IN (
SELECT party_identifier FROM
party_prod_tmp)
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
UPDATE info_transform.party_t
SET action = "D",
	status = "X"
WHERE id IN (
SELECT * FROM party_duplicated_tmp)
;
	
-- Changes
UPDATE info_transform.party_t
SET action = "C"
WHERE id IN (
SELECT transform_id FROM party_changed_tmp)
;

-- Adds
UPDATE info_transform.party_t
SET action = "A"
WHERE id IN (
SELECT transform_id FROM party_new_tmp)
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
	
INSERT INTO info_core.party
(party_identifier, dw_curr_in, dw_val_date, dw_exp_date,
type_of_party, telephone_number, mobile_number, email_address, 
internal_id, source, scd_hash, reporting_reference_date)
SELECT
party_identifier, 1 , p_date , 99991231 ,
type_of_party, telephone_number, mobile_number, email_address,
internal_id, source, scd_hash, reporting_reference_date
FROM info_transform.party_t
WHERE action = "A"
;


UPDATE info_transform.party_t
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
	
INSERT INTO info_core.party
(party_identifier, dw_curr_in, dw_val_date, dw_exp_date,
type_of_party, telephone_number, mobile_number, email_address, 
internal_id, source, scd_hash, reporting_reference_date)
SELECT
party_identifier, 1 , p_date , 99991231 ,
type_of_party, telephone_number, mobile_number, email_address, 
internal_id, source, scd_hash, reporting_reference_date
FROM info_transform.party_t
WHERE action = "C"
;


UPDATE info_core.party
SET dw_curr_in = 0,
	dw_exp_date = p_date
WHERE id IN (
SELECT prod_id FROM party_changed_tmp)
;
	
	
UPDATE info_transform.party_t
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
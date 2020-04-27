DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_truncate;
CREATE PROCEDURE info_process.sp_truncate(IN p_key VARCHAR(30))
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_truncate";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = CONCAT("Truncate extract and transform tables for key: ", p_key);
	
CASE p_key
	WHEN  'dgs_report' THEN
		TRUNCATE info_extract.customer_reference_01_e;
		TRUNCATE info_extract.customer_reference_02_e;
		TRUNCATE info_extract.customer_reference_03_e;
		
		TRUNCATE info_transform.natural_person_t;
		TRUNCATE info_transform.non_natural_person_t;
		
--	WHEN 'other p_key' THEN
--	   	TRUNCATE info_extract.another_table;
--	ELSE
	
END CASE;

	SELECT ROW_COUNT() INTO affected_rows;
	SELECT CURRENT_TIMESTAMP INTO end_dtm;
	SELECT TIMESTAMPDIFF(SECOND,start_dtm,end_dtm) INTO execution_time;
	INSERT INTO info_process.audit_log
	(process_name, step_number, step_desc, affected_rows, execution_time_sec)
	VALUES
	(process_name, step_number, step_desc, affected_rows, execution_time) ;	
		
END$$

DELIMITER ;
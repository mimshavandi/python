DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_validator_dgs_report;
CREATE PROCEDURE info_process.sp_validator_dgs_report(IN p_date DATE, IN p_key VARCHAR(30))
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;


	SET process_name = "sp_validator_dgs_report";
	
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = CONCAT("Validate report for: ", p_key , " - Date: " , p_date);
	
CASE p_key
	WHEN  'bank_account' THEN
		SELECT check_sql FROM info_process.report_validation_definition
		WHERE curr_in AND report_name = "bank_account" 
		AND validation_code = "omc009"
		INTO @check_sql;
		
		SELECT REPLACE(@check_sql,'@report_date',DATE_FORMAT(p_date, "%Y%m%d")) INTO @check_sql;
		
		PREPARE sql_st FROM @check_sql;
		
		EXECUTE sql_st;
		
		SELECT check_result FROM info_process.report_validation_result
		WHERE report_date = p_date
		AND report_name = "bank_account" 
		AND validation_code = "omc009"
		HAVING MAX(insert_dtm);
	
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
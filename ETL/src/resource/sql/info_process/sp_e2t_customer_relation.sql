DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_e2t_customer_relation;
CREATE PROCEDURE info_process.sp_e2t_customer_relation (IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_e2t_customer_relation";
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Make a temporary table for national id and internal id from customer relation.";

DROP TABLE IF EXISTS nationa_id_internal_id_tmp;
CREATE TEMPORARY TABLE  nationa_id_internal_id_tmp 
SELECT 	
national_id_number			AS party_identifier,
CUSTOMER_ID					AS internal_id
FROM info_extract.customer_reference_01_e
GROUP BY 1,2

UNION

SELECT 	
BSNNumber					AS party_identifier,
CUSTOMER_ID					AS internal_id
FROM info_extract.customer_reference_02_e
GROUP BY 1,2

UNION

SELECT 	
tax_pay_id					AS party_identifier,
CUSTOMER_ID					AS internal_id
FROM info_extract.customer_reference_03_e
GROUP BY 1,2
;
DROP TABLE IF EXISTS nationa_id_internal_id_tmp1;
CREATE TEMPORARY TABLE  nationa_id_internal_id_tmp1 
SELECT 	* FROM
nationa_id_internal_id_tmp
;
DROP TABLE IF EXISTS nationa_id_internal_id_tmp2;
CREATE TEMPORARY TABLE  nationa_id_internal_id_tmp2 
SELECT 	* FROM
nationa_id_internal_id_tmp
;
DROP TABLE IF EXISTS nationa_id_internal_id_tmp3;
CREATE TEMPORARY TABLE  nationa_id_internal_id_tmp3 
SELECT 	* FROM
nationa_id_internal_id_tmp
;
DROP TABLE IF EXISTS nationa_id_internal_id_tmp4;
CREATE TEMPORARY TABLE  nationa_id_internal_id_tmp4 
SELECT 	* FROM
nationa_id_internal_id_tmp
;
DROP TABLE IF EXISTS nationa_id_internal_id_tmp5;
CREATE TEMPORARY TABLE  nationa_id_internal_id_tmp5 
SELECT 	* FROM
nationa_id_internal_id_tmp
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
	SET step_desc = "Create temporary table for role party from source files and QC table";


DROP TABLE IF EXISTS party_role_tmp;
CREATE TEMPORARY TABLE  party_role_tmp 
SELECT 
report_date 	   			AS reporting_reference_date,
b.party_identifier			AS party_identifier,
CUSTOMER_ID					AS internal_id,
"depositor"					AS party_role,
"customer_01_relation"		AS source
FROM info_extract.customer_relation_01_e a
JOIN nationa_id_internal_id_tmp b ON a.CUSTOMER_ID = b.internal_id
WHERE 	asc_type IN ("Single", "Joint" , "Empowered")
AND 	report_date = p_date
GROUP BY 1,2,3,4

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
b.party_identifier			AS party_identifier,
ASC_CUSTOMER_ID				AS internal_id,
CASE WHEN asc_type = "Joint" THEN "depositor" ELSE "representative" END 	AS party_role,
"customer_01_relation"		AS source
FROM info_extract.customer_relation_01_e a
JOIN nationa_id_internal_id_tmp1  b ON a.CUSTOMER_ID = b.internal_id
WHERE 	asc_type IN ("Joint" , "Empowered")
AND 	report_date = p_date
GROUP BY 1,2,3,4

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
b.party_identifier			AS party_identifier,
CUSTOMER_ID					AS internal_id,
"depositor"					AS party_role,
"customer_02_relation"		AS source
FROM info_extract.customer_relation_02_e a
JOIN nationa_id_internal_id_tmp2  b ON a.CUSTOMER_ID = b.internal_id
WHERE 	joint_type IN ("Single", "Joint")
AND 	report_date = p_date
GROUP BY 1,2,3,4

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
b.party_identifier			AS party_identifier,
ASC_CUSTOMER_ID				AS internal_id,
CASE WHEN relation_type = "AccountHolder" THEN "depositor" ELSE "representative" END 	AS party_role,
"customer_02_relation"		AS source
FROM info_extract.customer_relation_02_e a
JOIN nationa_id_internal_id_tmp3  b ON a.CUSTOMER_ID = b.internal_id
WHERE 	joint_type IN ("Single", "Joint")
AND relation_type IN ("AccountHolder" , "Empowered") 
AND 	report_date = p_date
GROUP BY 1,2,3,4

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
b.party_identifier			AS party_identifier,
CUSTOMER_ID					AS internal_id,
"depositor"					AS party_role,
"customer_03_relation"		AS source
FROM info_extract.customer_relation_03_e a
JOIN nationa_id_internal_id_tmp4  b ON a.CUSTOMER_ID = b.internal_id
WHERE 	relation_type IN ("C", "E")
AND 	report_date = p_date
GROUP BY 1,2,3,4

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
b.party_identifier			AS party_identifier,
ASC_CUSTOMER_ID				AS internal_id,
CASE WHEN relation_type = "C" THEN "depositor" ELSE "representative" END	AS party_role,
"customer_03_relation"		AS source
FROM info_extract.customer_relation_03_e a
JOIN nationa_id_internal_id_tmp5  b ON a.CUSTOMER_ID = b.internal_id
WHERE 	relation_type IN ("Single", "Joint")
AND 	report_date = p_date
GROUP BY 1,2,3,4

UNION

SELECT 
reporting_reference_date, party_identifier, internal_id, party_role, source
FROM info_qc.party_role_qc
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
	SET step_number = "03";
	SET step_desc = "Set the status flag for QC table to Done";
	
UPDATE 	info_qc.party_role_qc
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
	SET step_number = "04";
	SET step_desc = "Separate clean and non clean data.";
	
DROP TABLE IF EXISTS party_role_clean_tmp;
CREATE TEMPORARY TABLE  party_role_clean_tmp 
SELECT * FROM party_role_tmp
WHERE 	reporting_reference_date IS NOT NULL
AND 	internal_id IS NOT NULL
AND		party_role IS NOT NULL
AND		party_identifier IS NOT NULL
;


DROP TABLE IF EXISTS party_role_non_clean_tmp;
CREATE TEMPORARY TABLE  party_role_non_clean_tmp 
SELECT * FROM party_role_tmp
WHERE 	reporting_reference_date IS NULL
OR	 	internal_id IS NULL
OR		party_role IS NULL
OR		party_identifier IS NULL
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
	SET step_desc = "Load data to transform table for party role";
	
		
INSERT INTO info_transform.party_role_t 
(party_identifier, party_role, internal_id, source, reporting_reference_date)
SELECT
party_identifier, GROUP_CONCAT(DISTINCT party_role SEPARATOR ";"),
GROUP_CONCAT(DISTINCT internal_id SEPARATOR ";"), GROUP_CONCAT(DISTINCT source SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT reporting_reference_date SEPARATOR ";")
FROM party_role_clean_tmp
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
	SET step_number = "06";
	SET step_desc = "Load data to QC table for party role";

INSERT INTO info_qc.party_role_qc
(party_identifier, party_role, internal_id, source, reporting_reference_date)
SELECT
party_identifier, party_role, internal_id, source, reporting_reference_date
FROM party_role_non_clean_tmp
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



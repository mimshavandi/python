DELIMITER $$
USE info_process;
DROP PROCEDURE IF EXISTS info_process.sp_e2t_party;
CREATE PROCEDURE info_process.sp_e2t_party (IN p_date DATE)
BEGIN

DECLARE process_name		VARCHAR(50);
DECLARE step_number 		VARCHAR(25);
DECLARE step_desc			VARCHAR(250);
DECLARE affected_rows		INT;
DECLARE start_dtm			TIMESTAMP;
DECLARE end_dtm				TIMESTAMP;
DECLARE execution_time      INT;

	SET process_name = "sp_e2t_party";
	
	SELECT CURRENT_TIMESTAMP INTO start_dtm ;
	SET step_number = "01";
	SET step_desc = "Create temporary table for party from source files and QC table";
	

DROP TABLE IF EXISTS party_tmp;
CREATE TEMPORARY TABLE  party_tmp 
SELECT 
report_date 	   			AS reporting_reference_date,
national_id_number			AS party_identifier,
TELEPHONENUMBER				AS telephone_number,
MOBILEPHONE					AS mobile_number,
EMAILADDRESS				AS email_address,
CUSTOMER_ID					AS internal_id,
"customer_01_reference"		AS source
FROM info_extract.customer_reference_01_e
WHERE report_date = p_date
GROUP BY 1,2,3,4,5,6,7

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
BSNNumber					AS party_identifier,
HomeTelephoneNumber			AS telephone_number,
MobileTelephoneNumber		AS mobile_number,
EMail1Address				AS email_address,
CUSTOMER_ID					AS internal_id,
"customer_02_reference"		AS source
FROM info_extract.customer_reference_02_e
WHERE report_date = p_date
GROUP BY 1,2,3,4,5,6,7

UNION

SELECT 
report_date 	   			AS reporting_reference_date,
tax_pay_id					AS party_identifier,
telephone_number			AS telephone_number,
mobile_number				AS mobile_number,
e_mail_address				AS email_address,
CUSTOMER_ID					AS internal_id,
"customer_03_reference"		AS source
FROM info_extract.customer_reference_03_e
WHERE report_date = p_date
GROUP BY 1,2,3,4,5,6,7

UNION 

SELECT 
reporting_reference_date, party_identifier, telephone_number, 
mobile_number, email_address, internal_id, source
FROM info_qc.party_qc
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
	SET step_desc = "Set the status flag for party QC table to Done";
	
UPDATE 	info_qc.party_qc
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
	SET step_desc = "Separate clean and non clean data for party; Making scd hash for clean data";
	
DROP TABLE IF EXISTS party_clean_tmp;
CREATE TEMPORARY TABLE  party_clean_tmp 
SELECT *, 
MD5(CONCAT(telephone_number, mobile_number, email_address)) AS scd_hash
FROM party_tmp
WHERE 	reporting_reference_date IS NOT NULL
AND 	party_identifier IS NOT NULL
AND		telephone_number IS NOT NULL
AND		mobile_number IS NOT NULL
AND		email_address IS NOT NULL
AND		internal_id IS NOT NULL
;


DROP TABLE IF EXISTS party_non_clean_tmp;
CREATE TEMPORARY TABLE  party_non_clean_tmp 
SELECT * FROM party_tmp
WHERE 	reporting_reference_date IS NULL
OR	 	party_identifier IS NULL
OR		telephone_number IS NULL
OR		mobile_number IS NULL
OR		email_address IS NULL
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


INSERT INTO info_transform.party_t 
(party_identifier, telephone_number, mobile_number, email_address, 
type_of_party, internal_id, source, scd_hash, reporting_reference_date)
SELECT 
a.party_identifier, GROUP_CONCAT(DISTINCT telephone_number SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT mobile_number SEPARATOR ";"), GROUP_CONCAT(DISTINCT email_address SEPARATOR ";"), 
"non natural" AS type_of_party,
GROUP_CONCAT(DISTINCT a.internal_id SEPARATOR ";"), GROUP_CONCAT(DISTINCT a.source SEPARATOR ";"), 
MD5(GROUP_CONCAT(DISTINCT a.scd_hash SEPARATOR ";")), GROUP_CONCAT(DISTINCT a.reporting_reference_date SEPARATOR ";")
FROM party_clean_tmp a
JOIN info_core.non_natural_person b
ON a.party_identifier = b.party_identifier
AND b.party_identifier IS NOT NULL
GROUP BY 1	
;

INSERT INTO info_transform.party_t 
(party_identifier, telephone_number, mobile_number, email_address, 
type_of_party, internal_id, source, scd_hash, reporting_reference_date)
SELECT 
a.party_identifier, GROUP_CONCAT(DISTINCT telephone_number SEPARATOR ";"), 
GROUP_CONCAT(DISTINCT mobile_number SEPARATOR ";"), GROUP_CONCAT(DISTINCT email_address SEPARATOR ";"), 
"natural" AS type_of_party,
GROUP_CONCAT(DISTINCT a.internal_id SEPARATOR ";"), GROUP_CONCAT(DISTINCT a.source SEPARATOR ";"), 
MD5(GROUP_CONCAT(DISTINCT a.scd_hash SEPARATOR ";")), GROUP_CONCAT(DISTINCT a.reporting_reference_date SEPARATOR ";")
FROM party_clean_tmp a
JOIN info_core.natural_person b
ON a.party_identifier = b.party_identifier
AND b.party_identifier IS NOT NULL
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

INSERT INTO info_qc.party_qc
(reporting_reference_date, party_identifier, telephone_number, 
mobile_number, email_address, internal_id, source)
SELECT
reporting_reference_date, party_identifier, telephone_number, 
mobile_number, email_address, internal_id, source
FROM party_non_clean_tmp
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



USE info_process;

DROP TABLE IF EXISTS info_process.report_validation_definition;
CREATE TABLE  info_process.report_validation_definition (
id                  	INT auto_increment,
curr_in					TINYINT,
val_date				DATE,
expr_date				DATE,
report_name				VARCHAR(50),
validation_code			VARCHAR(10),
check_sql	        	VARCHAR(550),
insert_dtm          	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
);

INSERT INTO info_process.report_validation_definition(
curr_in, val_date, expr_date, report_name, validation_code, check_sql)
VALUES
(1, 20200101, 99991231, 'bank_account', 'omc009',
'INSERT INTO info_process.report_validation_result ( 
report_date, report_name, validation_code, check_result)
SELECT @report_date, "bank_account", "omc009",
CASE WHEN COUNT(*) - COUNT(DISTINCT bank_account_identifier) = 0 THEN "OK" ELSE "KO" END FROM info_report.bank_account;'
);

INSERT INTO info_process.report_validation_definition(
curr_in, val_date, expr_date, report_name, validation_code, check_sql)
VALUES
(1, 20200101, 99991231, 'bank_account_ownership', 'omc009',
'INSERT INTO info_process.report_validation_result ( 
report_date, report_name, validation_code, check_result)
SELECT @report_date, "bank_account_ownership", "omc009",
SELECT 
CASE WHEN COUNT(*) - COUNT(DISTINCT party_identifier) = 0 THEN "OK" ELSE "KO" END FROM info_report.bank_account_ownership;'
);



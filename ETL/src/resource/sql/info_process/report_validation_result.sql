USE info_process;

DROP TABLE IF EXISTS info_process.report_validation_result;
CREATE TABLE  info_process.report_validation_result (
id                  	INT auto_increment,
report_date				DATE,
report_name				VARCHAR(50),
validation_code			VARCHAR(10),
check_result        	VARCHAR(2),
insert_dtm          	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
);
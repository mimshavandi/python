USE info_process;

DROP TABLE IF EXISTS info_process.audit_log;
CREATE TABLE  info_process.audit_log (
id                  	INT auto_increment,
process_name        	VARCHAR(50),
step_number         	VARCHAR(25),
step_desc         		VARCHAR(250),
affected_rows        	INT,
execution_time_sec		INT,
insert_dtm          	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
);
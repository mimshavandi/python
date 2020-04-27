USE info_core;

DROP TABLE IF EXISTS info_core.natural_person;
CREATE TABLE  info_core.natural_person (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
dw_curr_in          		TINYINT,
dw_val_date         		DATE,
dw_exp_date         		DATE,
nationality        			VARCHAR(150),
initials        			VARCHAR(150),
birthname        			VARCHAR(150),
affix_birth_name        	VARCHAR(150),
last_name        			VARCHAR(150),
affix_last_name        		VARCHAR(150),
date_of_birth				VARCHAR(150),
gender						VARCHAR(150),
vital_status 				VARCHAR(150),
internal_id        			VARCHAR(250),
source        				VARCHAR(150),
scd_hash					CHAR(34),
reporting_reference_date	DATE,
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;

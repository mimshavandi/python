DROP TABLE IF EXISTS info_transform.natural_person_t;
CREATE TABLE  info_transform.natural_person_t (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
action						VARCHAR(1),
status						VARCHAR(1),
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


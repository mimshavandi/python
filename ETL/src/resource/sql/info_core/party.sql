USE info_core;

DROP TABLE IF EXISTS info_core.party;
CREATE TABLE  info_core.party (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
dw_curr_in          		TINYINT,
dw_val_date         		DATE,
dw_exp_date         		DATE,
type_of_party				VARCHAR(150),
identifier_indicator		VARCHAR(150),
telephone_number			VARCHAR(150),
mobile_number				VARCHAR(150),
email_address				VARCHAR(150),
internal_id        			VARCHAR(250),
source        				VARCHAR(150),
scd_hash					CHAR(34),
reporting_reference_date	DATE,
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;



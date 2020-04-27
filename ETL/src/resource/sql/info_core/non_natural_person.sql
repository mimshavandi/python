USE info_core;

DROP TABLE IF EXISTS info_core.non_natural_person;
CREATE TABLE  info_core.non_natural_person (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
dw_curr_in          		TINYINT,
dw_val_date         		DATE,
dw_exp_date         		DATE,
registered_name        		VARCHAR(150),
registered_place        	VARCHAR(150),
registered_country        	VARCHAR(150),
legal_capacity        		VARCHAR(150),
enterprise_size        		VARCHAR(150),
internal_id        			VARCHAR(250),
source        				VARCHAR(150),
scd_hash					CHAR(34),
reporting_reference_date	DATE,
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
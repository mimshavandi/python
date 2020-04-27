USE info_core;

DROP TABLE IF EXISTS info_core.party_role;
CREATE TABLE  info_core.party_role (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
dw_curr_in          		TINYINT,
dw_val_date         		DATE,
dw_exp_date         		DATE,
party_role					VARCHAR(150),
internal_id        			VARCHAR(250),
source        				VARCHAR(150),
reporting_reference_date	DATE,
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
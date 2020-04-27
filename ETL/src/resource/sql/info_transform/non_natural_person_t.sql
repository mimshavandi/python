DROP TABLE IF EXISTS info_transform.non_natural_person_t;
CREATE TABLE  info_transform.non_natural_person_t (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
action						VARCHAR(1),
status						VARCHAR(1),
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

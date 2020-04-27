USE info_qc;

DROP TABLE IF EXISTS info_qc.non_natural_person_qc;
CREATE TABLE  info_qc.non_natural_person_qc (
id                  		INT auto_increment,
action						VARCHAR(15),
status						VARCHAR(15),
reporting_reference_date	DATE,
party_identifier        	VARCHAR(50),
registered_name        		VARCHAR(50),
registered_place        	VARCHAR(50),
registered_country        	VARCHAR(50),
legal_capacity        		VARCHAR(50),
enterprise_size        		VARCHAR(50),
internal_id        			VARCHAR(50),
source        				VARCHAR(50),
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
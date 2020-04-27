DROP TABLE IF EXISTS info_transform.party_role_t;
CREATE TABLE  info_transform.party_role_t (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
action						VARCHAR(1),
status						VARCHAR(1),
party_role					VARCHAR(150),
internal_id					VARCHAR(150),
source        				VARCHAR(150),
reporting_reference_date	DATE,
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;


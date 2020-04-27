DROP TABLE IF EXISTS info_transform.party_t;
CREATE TABLE  info_transform.party_t (
id                  		INT auto_increment,
party_identifier        	VARCHAR(150),
action						VARCHAR(1),
status						VARCHAR(1),
type_of_party				VARCHAR(150),
identifier_indicator		VARCHAR(150),
telephone_number			VARCHAR(150),
mobile_number				VARCHAR(150),
email_address				VARCHAR(150),
internal_id					VARCHAR(150),
source        				VARCHAR(150),
scd_hash					CHAR(34),
reporting_reference_date	DATE,
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
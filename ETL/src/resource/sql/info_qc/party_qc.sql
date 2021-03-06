USE info_qc;

DROP TABLE IF EXISTS info_qc.party_qc;
CREATE TABLE  info_qc.party_qc (
id                  		INT auto_increment,
action						VARCHAR(1),
status						VARCHAR(15),
reporting_reference_date	DATE,
party_identifier			VARCHAR(50),
telephone_number			VARCHAR(150),
mobile_number				VARCHAR(150),
email_address				VARCHAR(150),
internal_id					VARCHAR(50),
source						VARCHAR(50),
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;


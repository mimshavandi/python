USE info_qc;

DROP TABLE IF EXISTS info_qc.natural_person_qc;
CREATE TABLE  info_qc.natural_person_qc (
id                  		INT auto_increment,
action						VARCHAR(1),
status						VARCHAR(15),
reporting_reference_date	DATE,
party_identifier			VARCHAR(50),
nationality					VARCHAR(50),
initials					VARCHAR(50),
birthname					VARCHAR(50),
affix_birth_name			VARCHAR(50),
last_name					VARCHAR(50),
affix_last_name				VARCHAR(50),
date_of_birth				VARCHAR(50),
gender						VARCHAR(50),
vital_status				VARCHAR(50),
internal_id					VARCHAR(50),
source						VARCHAR(50),
insert_dtm           		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
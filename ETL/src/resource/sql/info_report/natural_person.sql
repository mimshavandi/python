USE info_report;

DROP TABLE IF EXISTS info_report.natural_person;
CREATE TABLE  info_report.natural_person (
bank_identifier        				VARCHAR(20),
reporting_reference_date			DATE,
party_identifier					VARCHAR(34),
nationality							VARCHAR(10),
initials							VARCHAR(20),
birthname							VARCHAR(70),
affix_of_birthname					VARCHAR(10),
lastname							VARCHAR(70),
affix_of_lastname					VARCHAR(10),
date_of_birth						VARCHAR(100),
gender								VARCHAR(10),
vital_status						VARCHAR(10),
primary key(party_identifier)
)
;




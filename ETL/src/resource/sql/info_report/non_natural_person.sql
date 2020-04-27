USE info_report;

DROP TABLE IF EXISTS info_report.non_natural_person;
CREATE TABLE  info_report.non_natural_person (
bank_identifier        				VARCHAR(20),
reporting_reference_date			DATE,
party_identifier					VARCHAR(34),
registered_name        				VARCHAR(70),
registered_place        			VARCHAR(100),
registered_country        			VARCHAR(10),
legal_capacity        				VARCHAR(1),
enterprise_size        				VARCHAR(1),
primary key(party_identifier)
)
;





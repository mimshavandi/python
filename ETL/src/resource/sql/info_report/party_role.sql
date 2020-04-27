USE info_report;

DROP TABLE IF EXISTS info_report.party_role;
CREATE TABLE  info_report.party_role (
bank_identifier        				VARCHAR(20),
reporting_reference_date			DATE,
party_identifier					VARCHAR(34),
role_of_party						VARCHAR(34),
primary key(party_identifier)
)
;




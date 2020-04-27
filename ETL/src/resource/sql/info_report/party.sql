USE info_report;

DROP TABLE IF EXISTS info_report.party;
CREATE TABLE  info_report.party (
bank_identifier        				VARCHAR(20),
reporting_reference_date			DATE,
party_identifier        			VARCHAR(34),
type_of_party						VARCHAR(70),
identifier_indicator				VARCHAR(20),
telephone_number					VARCHAR(20),
mobile_number						VARCHAR(20),
email_address						VARCHAR(254),
primary key(party_identifier)
)
;

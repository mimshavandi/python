USE info_report;

DROP TABLE IF EXISTS info_report.bank_account_ownership;
CREATE TABLE  info_report.bank_account_ownership (
bank_identifier        				VARCHAR(20),
reporting_reference_date			DATE,
party_identifier					VARCHAR(34),
role_of_party						VARCHAR(34),
bank_account_identifier				VARCHAR(34),			
participation_percentage			DECIMAL(7,6),
primary key(bank_account_identifier)
)
;

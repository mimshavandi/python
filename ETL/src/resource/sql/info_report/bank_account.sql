USE info_report;

DROP TABLE IF EXISTS info_report.bank_account;
CREATE TABLE  info_report.bank_account (
bank_identifier        				VARCHAR(20),
reporting_reference_date			DATE,
bank_account_identifier				VARCHAR(34),	
type_of_bank_account				VARCHAR(34),
type_of_third_party_account			VARCHAR(34),
eligible_account					VARCHAR(34),
bank_account_number					VARCHAR(34),			
ascription							VARCHAR(255),			
account_label						VARCHAR(50),			
currency							VARCHAR(5),					
balance								DECIMAL(50,2),
interest							DECIMAL(50,2),				
blocked_account_indicator			TINYINT,	
country_of_branch_of_account		VARCHAR(5),
count_of_depositors					INT,
primary key(bank_account_identifier)
)
;




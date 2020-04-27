DROP TABLE IF EXISTS info_transform.bank_account_t;
CREATE TABLE  info_transform.bank_account_t (
id                  			INT auto_increment,
bank_account_identifier     	VARCHAR(150),
action							VARCHAR(1),
status							VARCHAR(1),
type_of_bank_account			VARCHAR(150),
type_of_third_party_account		VARCHAR(150),
eligible_account				VARCHAR(150),
bank_account_number				VARCHAR(150),
ascription						VARCHAR(150),
account_label					VARCHAR(150),
currency						VARCHAR(150),
balance							VARCHAR(150),
interest						VARCHAR(150),
blocked_account_indicator		VARCHAR(150),
country_of_branch_of_account	VARCHAR(150),
count_of_depositors				VARCHAR(150),
internal_id						VARCHAR(150),
source        					VARCHAR(150),
scd_hash						CHAR(34),
reporting_reference_date		DATE,
insert_dtm           			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;

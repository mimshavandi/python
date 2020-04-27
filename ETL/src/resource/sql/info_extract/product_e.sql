USE info_extract;

DROP TABLE IF EXISTS info_extract.product_e;
CREATE TABLE  info_extract.product_e (
id 								int NOT NULL AUTO_INCREMENT,
report_date 					varchar(150) DEFAULT NULL,
CUSTOMER_ID 					varchar(150) DEFAULT NULL,
bank_account_identifier 		varchar(150) DEFAULT NULL,
bank_account_number 			varchar(150) DEFAULT NULL,
type_of_bank_account 			varchar(150) DEFAULT NULL,
eligible_account 				varchar(150) DEFAULT NULL,
account_label 					varchar(150) DEFAULT NULL,
currency 						varchar(150) DEFAULT NULL,
balance 						varchar(150) DEFAULT NULL,
interest 						varchar(150) DEFAULT NULL,
blocked_account_indicator 		varchar(150) DEFAULT NULL,
country_of_branch_of_account 	varchar(150) DEFAULT NULL,
blockage_reason 				varchar(150) DEFAULT NULL,
explanation 					varchar(150) DEFAULT NULL,
bank_identifier 				varchar(150) DEFAULT NULL,
branch 							varchar(150) DEFAULT NULL,
insert_dtm 						timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
)
;




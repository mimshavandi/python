USE info_extract;

DROP TABLE IF EXISTS info_extract.customer_reference_03_e;
CREATE TABLE  info_extract.customer_reference_03_e (
id                  			INT auto_increment,
report_date              		DATE,
CUSTOMER_ID              		VARCHAR(150),
birth_date              		VARCHAR(150),
tax_pay_id              		VARCHAR(150),
name_1              			VARCHAR(150),
given_names              		VARCHAR(150),
family_name              		VARCHAR(150),
affix              				VARCHAR(150),
street_1              			VARCHAR(150),
town_country_1              	VARCHAR(150),
postal_code_1              		VARCHAR(150),
country_1              			VARCHAR(150),
residence              			VARCHAR(150),
nationality              		VARCHAR(150),
birth_place              		VARCHAR(150),
birth_country              		VARCHAR(150),
legal_form              			VARCHAR(150),
legal_id              			VARCHAR(150),
legal_doc_name              	VARCHAR(150),
telephone_number              	VARCHAR(150),
mobile_number              		VARCHAR(150),
e_mail_address              	VARCHAR(150),
child_flag              		VARCHAR(150),
type_of_person              	VARCHAR(150),
title							VARCHAR(150),
insert_dtm           			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;


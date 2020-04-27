USE info_extract;

DROP TABLE IF EXISTS info_extract.customer_relation_03_e;
CREATE TABLE  info_extract.customer_relation_03_e (
id                  			INT auto_increment,
report_date					    VARCHAR(150),
CUSTOMER_ID					    VARCHAR(150),
relation_type					VARCHAR(150),
ASC_CUSTOMER_ID					VARCHAR(150),
insert_dtm           			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
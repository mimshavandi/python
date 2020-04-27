USE info_extract;

DROP TABLE IF EXISTS info_extract.customer_reference_02_e;
CREATE TABLE  info_extract.customer_reference_02_e (
id                  			INT auto_increment,
report_date						DATE,
CUSTOMER_ID						VARCHAR(150),
Birthday						VARCHAR(150),
FullName						VARCHAR(150),
Title							VARCHAR(150),
Initials						VARCHAR(150),
FirstName						VARCHAR(150),
LastName						VARCHAR(150),
FamilyName						VARCHAR(150),
MaidenName						VARCHAR(150),
Gender							VARCHAR(150),
BSNNumber						VARCHAR(150),
EMail1Address					VARCHAR(150),
HomeTelephoneNumber				VARCHAR(150),
MobileTelephoneNumber			VARCHAR(150),
BirthCity						VARCHAR(150),
BirthCountry					VARCHAR(150),
Residence						VARCHAR(150),
Nationality						VARCHAR(150),
Type							VARCHAR(150),
StreetName						VARCHAR(150),
HouseNumber						VARCHAR(150),
HouseNumberAddition				VARCHAR(150),
PostalCode						VARCHAR(150),
City							VARCHAR(150),
Country							VARCHAR(150),
IsPrimary						VARCHAR(150),
PortfolioStatus					VARCHAR(150),
PersonStatus					VARCHAR(150),
insert_dtm           			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key(id)
)
;
csv_dict = {
            'cstmr_ref_01' : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/customer_01_reference.csv' 
                                INTO TABLE info_extract.customer_reference_01_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID,party_birth_date,customer_type,type_of_person,FullName,
                                FIRSTNAME,LASTNAME,Initials,STREET,HOUSENUMBER,HOUSENUMBERADDITION,CITY,POSTALCODE,
                                ADDRESSLINE1,ADDRESSLINE2,COUNTRY,RESIDENCE,NATIONALITY,PLACEOFBIRTH,COUNTRYOFBIRTH,
                                TELEPHONENUMBER,MOBILEPHONE,EMAILADDRESS,TITLE,legal_capacity,national_id_type,
                                national_id_country,national_id_number,document_type,document_country,document_number)
                                ;
                                """
,
            'cstmr_ref_02' : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/customer_02_reference.csv'
                                INTO TABLE info_extract.customer_reference_02_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID,Birthday,FullName,Title,Initials,FirstName,LastName,
                                FamilyName,MaidenName,Gender,BSNNumber,EMail1Address,HomeTelephoneNumber,
                                MobileTelephoneNumber,BirthCity,BirthCountry,Residence,Nationality,Type,
                                StreetName,HouseNumber,HouseNumberAddition,PostalCode,City,Country,IsPrimary,
                                PortfolioStatus,PersonStatus)
                                ;
                                """
,
            'cstmr_ref_03' : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/customer_03_reference.csv'
                                INTO TABLE info_extract.customer_reference_03_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID,birth_date,tax_pay_id,name_1,given_names,family_name,affix,
                                street_1,town_country_1,postal_code_1,country_1,residence,nationality,birth_place,
                                birth_country,legal_form,legal_id,legal_doc_name,telephone_number,mobile_number,
                                e_mail_address,child_flag,type_of_person,title)
                                ;
                                """
                                
,
            'cstmr_rel_01' : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/customer_01_relation.csv'
                                INTO TABLE info_extract.customer_relation_01_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID, asc_type, ASC_CUSTOMER_ID)
                                ;
                                """
                                
,
            'cstmr_rel_02' : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/customer_02_relation.csv'
                                INTO TABLE info_extract.customer_relation_02_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID,joint_type,relation_type,ASC_CUSTOMER_ID)
                                ;
                                """
                                
,
            'cstmr_rel_03' : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/customer_03_relation.csv'
                                INTO TABLE info_extract.customer_relation_03_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID,relation_type,ASC_CUSTOMER_ID)
                                ;
                                """
                                
,
            'product'      : r"""
                                LOAD DATA LOCAL INFILE 
                                '#PATH#/product.csv'
                                INTO TABLE info_extract.product_e
                                FIELDS TERMINATED BY ',' 
                                ENCLOSED BY '"' 
                                LINES TERMINATED BY '\r\n'
                                IGNORE 1 LINES
                                (report_date,CUSTOMER_ID,bank_account_identifier,type_of_bank_account,
                                eligible_account,bank_account_number,account_label,currency,balance,
                                interest,blocked_account_indicator,country_of_branch_of_account,
                                blockage_reason,explanation,bank_identifier,branch)
                                ;
                                """
            }

csv_dict = {
            'natural_person' : r"""
                                SELECT * FROM info_report.natural_person
                                INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/natural_person.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
,
            'non_natural_person' : r"""
                                SELECT * FROM info_report.non_natural_person
                                INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/non_natural_person.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
,
            'party' : r"""
                                SELECT * FROM info_report.party
                                INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/party.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
                                
,
            'party_role' : r"""
                                SELECT * FROM info_report.party_role
                                INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/party_role.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
                                
,
            'bank_account' : r"""
                                SELECT * FROM info_report.bank_account
                                INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank_account.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
                                
,
            'bank_account_ownership' : r"""
                                SELECT * FROM info_report.bank_account_ownership
                                INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank_account_ownership.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
            }

csv_dict = {
            'natural_person' : r"""
                                SELECT * FROM info_report.natural_person
                                INTO OUTFILE '#PATH#/natural_person.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
,
            'non_natural_person' : r"""
                                SELECT * FROM info_report.non_natural_person
                                INTO OUTFILE '#PATH#/non_natural_person.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
,
            'party' : r"""
                                SELECT * FROM info_report.party
                                INTO OUTFILE '#PATH#/party.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
                                
,
            'party_role' : r"""
                                SELECT * FROM info_report.party_role
                                INTO OUTFILE '#PATH#/party_role.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
                                
,
            'bank_account' : r"""
                                SELECT * FROM info_report.bank_account
                                INTO OUTFILE '#PATH#/bank_account.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
                                
,
            'bank_account_ownership' : r"""
                                SELECT * FROM info_report.bank_account_ownership
                                INTO OUTFILE '#PATH#/bank_account_ownership.csv' 
                                FIELDS ENCLOSED BY '"' 
                                TERMINATED BY ',' 
                                ESCAPED BY '' 
                                LINES TERMINATED BY '\r\n'
                                ;
                                """
            }

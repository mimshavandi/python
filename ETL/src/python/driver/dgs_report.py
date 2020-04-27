from python.helper.csv2db import csv2db
from python.helper.db2csv import db2csv
from python.helper.logger import write_log
from python.helper.sp_runner import sp_runner 
from python.helper.validator import validator

process_name = "dgs_report"
truncate_key = "dgs_report"
import_code_list = ['cstmr_ref_01' , 'cstmr_ref_02' , 'cstmr_ref_03',
                    'cstmr_rel_01' , 'cstmr_rel_02' , 'cstmr_rel_03',
                    'product'
                    ]
sp_list = ['sp_truncate',
           'sp_e2t_customer_reference',
           'sp_t2p_customer_reference',
           'sp_e2t_customer_relation' ,
           'sp_t2p_customer_relation' ,
           'sp_e2t_party',
           'sp_t2p_party',
           'sp_e2t_bank_account',
           'sp_t2p_bank_account',
           'sp_p2r_bank_account_ownership',
           'sp_p2r_bank_account',
           'sp_p2r_natural_person',
           'sp_p2r_non_natural_person',
           'sp_p2r_party_role',
           'sp_p2r_party'
#           'sp_validator_dgs_report'                   
          ]
validator_process = 'sp_validator_dgs_report'
validation_list = ['bank_account',   
                  ]
export_list = ['natural_person',
               'non_natural_person',
               'party',
               'party_role',
               'bank_account_ownership',
               'bank_account']
process_date = '20190331'

def driver(process_name, truncate_key, import_code_list, sp_list, process_date):
    
    write_log("Start process: " , process_name)
    write_log("Process_date: " , process_date)
    
    write_log("Truncating extract and transform tables")
    sp_runner('sp_truncate', truncate_key)

    write_log("Importing CSV for: " , import_code_list)    
    for import_code in import_code_list:
        csv2db(import_code)
        write_log("Loading csv load key: ", import_code)
        
    write_log("Running stored procedures from the list")
    for sp_name in sp_list:
        sp_runner(sp_name, process_date)
        write_log ("Running: ", sp_name, " for date: ", process_date)
        
    write_log("Validating reports from the validation list")
    for val_key in validation_list:
        validator(validator_process, process_date, val_key)
    
    write_log("Exporting data to csv files")    
    for export_code in export_list:
        db2csv(export_code)
        
    write_log("End of processing!")
    
    
driver(process_name, truncate_key, import_code_list, sp_list, process_date)
    
        
    

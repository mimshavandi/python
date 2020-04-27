from mysql.connector import Error
from python.helper.config.db2csv import *
from python.helper.db import db_connect
from python.helper.logger import write_log
import shutil
import os
import fnmatch


def db2csv(export_code):
    try:
        connection = db_connect("info_report")
        sql_select_Query = csv_dict[export_code]
        cursor = connection.cursor()
        cursor.execute(sql_select_Query)
        connection.commit()
        write_log("Export db2csv key is: ", export_code)
        write_log("Total number of Exported rows is: ", cursor.rowcount)

        src_dir = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/"
        dst_dir = "C:/Users/mahdi/eclipse-workspace/GBI_PROJECT/src/resource/reports/"
        
        for root, dirnames, filenames in os.walk(src_dir):
            for filename in fnmatch.filter(filenames, '*.csv'):
                shutil.move(os.path.join(root, filename),dst_dir)

    except Error as e:
        write_log("Error exporting data to csv: ", e)
    finally:
        if (connection.is_connected()):
            connection.close()
            cursor.close()
            write_log("MySQL connection is closed")

#test
#for import_code in ['cstmr_rel_01','cstmr_rel_02','cstmr_rel_03']:
#db2csv('non_natural_person')

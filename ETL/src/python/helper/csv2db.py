from mysql.connector import Error
from python.helper.config.csv2db import *
from python.helper.db import db_connect
from python.helper.logger import write_log


def csv2db(import_code):
    try:
        connection = db_connect("info_extract")
        sql_select_Query = csv_dict[import_code]
        cursor = connection.cursor()
        cursor.execute(sql_select_Query)
        connection.commit()
        write_log("Import csv2db key is: ", import_code)
        write_log("Total number of imported rows is: ", cursor.rowcount)
    except Error as e:
        write_log("Error importing data to MySQL table: ", e)
    finally:
        if (connection.is_connected()):
            connection.close()
            cursor.close()
            write_log("MySQL connection is closed")

#test
#for import_code in ['cstmr_rel_01','cstmr_rel_02','cstmr_rel_03']:
#    csv2db(import_code)

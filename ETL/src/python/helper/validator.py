import mysql.connector
from python.helper.logger import write_log
from python.helper.db import db_connect


def validator(sp_name, p_date, p_key):
    try:
        connection = db_connect("info_process")
        cursor = connection.cursor()
        args = (p_date, p_key,)
        cursor.callproc(sp_name, args)
        result = cursor.fetchone()
        connection.commit()

        
        # print results
        write_log("executing validator stored procedure: " + sp_name)
        for result in cursor.stored_results():
            write_log("Validation status: " , result.fetchone()[0])

    except mysql.connector.Error as error:
        write_log("Conclusion: Failed to execute stored procedure: {}".format(error))
    finally:
        if (connection.is_connected()):
            cursor.close()
            connection.close()
            write_log("Conclusion: MySQL connection is closed")

#test
#validator('sp_validator_dgs_report', '20190331', 'bank_account')
            
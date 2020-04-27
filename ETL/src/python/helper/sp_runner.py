import mysql.connector
from python.helper.logger import write_log
from python.helper.db import db_connect


def sp_runner(sp_name, parameter):
    try:
        connection = db_connect("info_process")
        cursor = connection.cursor()
        args = (parameter,)
        cursor.callproc(sp_name, args)
        connection.commit()
        # print results
        write_log("executing stored procedure: " + sp_name)
        for result in cursor.stored_results():
            write_log(result.fetchall())
    
    except mysql.connector.Error as error:
        write_log("Conclusion: Failed to execute stored procedure: {}".format(error))
    finally:
        if (connection.is_connected()):
            cursor.close()
            connection.close()
            write_log("Conclusion: MySQL connection is closed")
            
#test
#sp_runner('sp_t2p_customer_reference', '20190331')
            
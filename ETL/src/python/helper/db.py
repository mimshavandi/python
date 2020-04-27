import mysql.connector

def db_connect(database):
    return mysql.connector.connect(host='localhost',
                            database=database,
                            user='root',
                            password='Anarisorkh88.',
                            auth_plugin='mysql_native_password',
                            allow_local_infile = True)

import mysql.connector
import pymysql
pymysql.install_as_MySQLdb()
from sqlalchemy import create_engine

def db_connect(database):
    return mysql.connector.connect(host='localhost',
                            database=database,
                            user='root',
                            password='Anarisorkh88.',
                            auth_plugin='mysql_native_password',
                            allow_local_infile = True)


def db_engine(database):  
    connection_string =   'mysql://root:Anarisorkh88.@localhost/' + database
    return create_engine(connection_string)


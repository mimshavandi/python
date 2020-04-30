from python.setting  import TMP_DIR
import os
import pandas as pd
from python.helper.db import db_engine


def xlsx2db(xlsx, sheet, database, table, header_row, eliminate_start, eliminate_end):
    loc = os.path.join(TMP_DIR,xlsx) 
    loc = loc.replace(os.path.sep, '/')
    xls_file = pd.ExcelFile(loc)
    df = xls_file.parse(sheet,header=None)
    df.columns = df.iloc[header_row]
    df = df.drop(df.index[eliminate_start:eliminate_end])
    engine = db_engine(database)
    df.to_sql(table, engine,if_exists='replace', index = None)
    
#test    
#xlsx2db('MarketWatchPlus-1399_2_11.xlsx', 'دیده بان بازار', 'info_test', 'test' , 2, 0, 3)    









# To open Workbook 
#wb = xlrd.open_workbook(loc) 
#sheet = wb.sheet_by_index(0) 
#print(type(sheet))

  
# For row 0 and column 0 
#print(sheet.cell_value(5, 0))
from datetime import date
from datetime import datetime


def write_log(*args):
    today = str(date.today())
    log_file = r"C:\Users\mahdi\eclipse-workspace\GBI_PROJECT\src\resource\log\message_" + today + ".log"
    log_file = open(log_file,"a+")
    line = str(datetime.now()) + " : " + ' '.join([str(a) for a in args])
    log_file.write(line+'\n')
    print(line)
    

    
    
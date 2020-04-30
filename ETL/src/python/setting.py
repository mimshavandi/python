import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE_DIR = BASE_DIR.replace(os.path.sep, '/')

CSV_IN_DIR = os.path.join(BASE_DIR, 'resource', 'csv')
CSV_IN_DIR = CSV_IN_DIR.replace(os.path.sep, '/')


CSV_OUT_DIR = os.path.join(BASE_DIR, 'resource', 'reports')
CSV_OUT_DIR = CSV_OUT_DIR.replace(os.path.sep, '/')

TMP_DIR = os.path.join(BASE_DIR, 'resource', 'tmp')
TMP_DIR = TMP_DIR.replace(os.path.sep, '/')

MY_SQL_DIR = 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/'

chromedriver = "C:/Python/Py3.8/chromedriver.exe"
phantomjs = "C:/Python/Py3.8/phantomjs-2.1.1-windows/bin/phantomjs.exe"
firefox = "C:/Python/Py3.8/geckodriver.exe"
downloads = "C:/Users/mahdi/Downloads/"


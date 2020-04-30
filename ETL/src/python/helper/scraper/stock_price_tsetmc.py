from selenium import webdriver
import shutil, os, fnmatch, time
from python.setting  import TMP_DIR, chromedriver, downloads
from python.helper.logger import write_log
from selenium.webdriver.chrome.options import Options


options = Options()
#options.add_argument("--start-minimized")
options.add_argument("window-size=10,10")
driver = webdriver.Chrome(options= options, executable_path=chromedriver)
driver.minimize_window()
write_log ("Opening TSETMC website for downloading stock price list.")
driver.get("http://members.tsetmc.com/tsev2/excel/MarketWatchPlus.aspx?d=0")
time.sleep(15)
driver.quit()
write_log ("Closing TSETMC website.")   
for root, dirnames, filenames in os.walk(downloads):
    for filename in fnmatch.filter(filenames, 'MarketWatchPlus*'):
        write_log ("Moving file: ", filename, "to tmp directory.")  
        shutil.move(os.path.join(root, filename),TMP_DIR)
        return filename
write_log ("End of web scraping for TSETMC")  

        
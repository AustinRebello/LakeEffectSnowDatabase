from datetime import datetime
import time
import sys
   
 
class processRadar:
    def __init__(self,startTime,endTime):
        self.startTime = startTime
        self.endTime = endTime
        self.hours = 0
        self.urlStart = "https://mesonet.agron.iastate.edu/GIS/apps/rview/warnings.phtml?osite=CLE&tzoff=0&layers%5B%5D=nexrad&layers%5B%5D=warnings&layers%5B%5D=cwas&layers%5B%5D=uscounties&layers%5B%5D=blank&site=CLE&tz=UTC&archive=yes&"
        self.urlEnd = "filter=0&cu=0&sortcol=fcster&sortdir=DESC&lsrlook=%2B&lsrwindow=15"
        
    def run(self):
        st = time.strptime(self.startTime,"%Y/%m/%d/%H")
        startUTCBase = datetime(st.tm_year, st.tm_mon, st.tm_mday, st.tm_hour)
        stUnix = (startUTCBase - datetime(1970,1,1)).total_seconds()
        et = time.strptime(self.endTime,"%Y/%m/%d/%H")
        endUTCBase = datetime(et.tm_year, et.tm_mon, et.tm_mday, et.tm_hour)
        etUnix = (endUTCBase - datetime(1970,1,1)).total_seconds()
        t = stUnix
        while t < etUnix:
            self.hours +=1
            t+=3600
        
        url = self.urlStart
        url = url +"year={}&month={}&day={}&hour={}&minute=0".format(endUTCBase.year,endUTCBase.month,endUTCBase.day,endUTCBase.hour)
        url = url +"&warngeo=sbw&zoom=250&imgsize=1280x1024&loop=1&"
        url = url +"frames={}&interval=10&".format(str(self.hours*6))
        url = url + self.urlEnd

        print(url)
        
args = sys.argv
processRadar(args[1], args[2]).run()
#processRadar("2021/01/17/21","2021/01/19/02").run()

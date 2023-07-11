from datetime import datetime
import time
import sys
   
 
class processRadar:
    #Initializes the class Object when the class is called at the bottom of the file
    def __init__(self,startTime,endTime, station):
        self.startTime = startTime
        self.endTime = endTime
        self.hours = 0
        self.urlStart = "https://mesonet.agron.iastate.edu/GIS/apps/rview/warnings.phtml?osite="+station+"&tzoff=0&layers%5B%5D=nexrad&layers%5B%5D=warnings&layers%5B%5D=cwas&layers%5B%5D=uscounties&layers%5B%5D=blank&site="+station+"&tz=UTC&archive=yes&"
        self.urlEnd = "filter=0&cu=0&sortcol=fcster&sortdir=DESC&lsrlook=%2B&lsrwindow=15"
        
    #Runs the generation of the radar archived URL
    def run(self):
        #Formats the date information into usable form
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
        
        #Generates the URL based off of the generated date information, accounting for DST and Leap Years
        url = self.urlStart
        url = url +"year={}&month={}&day={}&hour={}&minute=0".format(endUTCBase.year,endUTCBase.month,endUTCBase.day,endUTCBase.hour)
        url = url +"&warngeo=sbw&zoom=250&imgsize=1280x1024&loop=1&"
        url = url +"frames={}&interval=10&".format(str(self.hours*6))
        url = url + self.urlEnd

        print(url)
        
args = sys.argv
processRadar(args[1], args[2], args[3]).run()


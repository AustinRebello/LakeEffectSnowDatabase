import sys
import json
import time
import urllib.request as request
from urllib.error import HTTPError
import datetime

class processRealObservations:
    def __init__(self, startDate, endDate):
        self.url = "https://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR="
        self.startDate = startDate
        self.endDate = endDate
        self.compiledRows = []
        self.dates = []
        
        
    def run(self):
        self.getDates()
        self.getSurfaceObs("72632")
        self.getSurfaceObs("72528")
        
        jsonOutput = json.dumps(self.compiledRows)
        print(jsonOutput)
        
        
    def getSurfaceObs(self, station):
        
        
        for date in self.dates:
            url = self.url + str(date[0])+"&MONTH="+date[1]+"&FROM="+date[2]+"&TO="+date[2]+"&STNM="+station
            
            sur = []
            ntf = []
            eft = []
            shd = []
            validData = False
            
            try:
                response = request.urlopen(url)
            except HTTPError as err:
                continue
            
            data = response.read().splitlines()
            for line in data:
                lineData = line.decode('utf-8')
                if(lineData[1:5]=="1000"):
                    validData = True
                elif(validData and sur == []):
                    sur = self.processLine(lineData)
                elif (lineData[2:5]=="925"):
                    ntf = self.processLine(lineData)
                elif (lineData[2:5]=="850"):
                    eft = self.processLine(lineData)
                elif (lineData[2:5]=="700"):
                    shd = self.processLine(lineData)
                    break
                
            
            if(station == "72528"):
                stat = "Buffalo"
            else:
                stat = "Detroit"
            
            if(validData):
                self.compiledRows.append([stat, str(date[0])+"/"+str(date[1])+"/"+date[2][0:2]+"/"+date[2][2:], 
                                      sur[0], sur[1], sur[2], sur[3], sur[4], sur[5], sur[6],
                                      ntf[0], ntf[1], ntf[2], ntf[3], ntf[4], ntf[5], ntf[6],
                                      eft[0], eft[1], eft[2], eft[3], eft[4], eft[5], eft[6],
                                      shd[0], shd[1], shd[2], shd[3], shd[4], shd[5], shd[6]])
            #Process Date here
                                
    def getDates(self):
        sd = time.strptime(self.startDate,"%Y/%m/%d/%H")
        ed = time.strptime(self.endDate,"%Y/%m/%d/%H")
        
        newSD = datetime.datetime(sd.tm_year, sd.tm_mon, sd.tm_mday, 0)
        newED = datetime.datetime(ed.tm_year, ed.tm_mon, ed.tm_mday, 0)
        
        newED = newED + datetime.timedelta(days = 1)

        while(newSD<=newED):
            day = str(newSD.day)
            if newSD.day < 10:
                day = "0"+str(newSD.day)
            hour = str(newSD.hour)
            if newSD.hour < 12:
                hour = "0"+str(newSD.hour)            
            month = str(newSD.month)
            if(newSD.month<12):
                month = "0"+str(newSD.month)                            
            self.dates.append([newSD.year, month, day+hour])
            
            newSD = newSD + datetime.timedelta(hours = 12)
        
    def processLine(self, line):
        line = line.split(" ")
        while "" in line:
            line.remove("")
            
        #Pressure Height Temp DP RelHum WindDir WindSp
        return([line[0], line[2], line[3], line[4], line[6], line[7], line[1]])

args = sys.argv
processRealObservations(args[1], args[2]).run()       
#processRealObservations("2021/01/31/21","2021/02/03/02").run()   

            
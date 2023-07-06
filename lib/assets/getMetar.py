import sys
import json
import numpy as np
import time
import math
import urllib.request as request
import re
import metpy.calc as mc
from metpy.units import units
from datetime import datetime
from datetime import date, timedelta
from time import mktime


urlFront = 'https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py?'
urlMiddle = '&data=tmpc&data=dwpc&data=relh&data=drct&data=sknt&data=mslp&data=vsby&data=gust&data=wxcodes&data=peak_wind_gust&data=peak_wind_drct&data=peak_wind_time&'
urlEnd = '&tz=Etc%2FUTC&format=onlycomma&latlon=no&elev=no&missing=M&trace=T&direct=no&report_type=3&report_type=4'


class processMetar:
    def __init__(self,startTime,endTime):
        self.urlFront = urlFront
        self.urlMiddle = urlMiddle
        self.urlEnd = urlEnd
        self.startTime = startTime
        self.endTime = endTime
        self.startDate = date.fromisoformat("2000-01-01")
        self.endDate = date.fromisoformat("2000-01-01")
        self.year1 = 0
        self.month1 = 0
        self.day1 = 0
        self.hour1 = 0
        self.year2 = 0
        self.month2 = 0
        self.day2 = 0
        self.hour2 = 0
        self.stations = ["CLE","ERI","GKJ", "BKL", "CGF", "LNN", "HZY", "YNG", "POV", "AKR", "CAK", "LPR"]
        self.cape = 0
        self.times=[]
        self.bulkShearValues = []
        self.compiledRows = []
        self.startDay = date.fromisoformat("2000-01-01")
        self.startHour = 0
        self.endDate = date.fromisoformat("2000-01-01")
        self.endHour = 0
        
    def run(self):
        """Run it!"""
        self.setUpTimeRange()
        for station in self.stations:
            self.setStartDate()
            self.getMetarData(station)
        jsonOutput = json.dumps(self.compiledRows)
        print(jsonOutput)
        
    def formatISO(self, y, m, d):
        month = str(m)
        day = str(d)
        if len(month)==1:
            month = "0"+month
        if len(day)==1:
            day = "0"+day
        return str(y)+"-"+month+"-"+day
        
        
    def setUpTimeRange(self):
        """Get a list of all the hours w/i the provided time range"""
        st = time.strptime(self.startTime,"%Y/%m/%d/%H")
        et = time.strptime(self.endTime,"%Y/%m/%d/%H")
        newStart = datetime.fromtimestamp(mktime(st)) - timedelta(hours = 1)
        newEnd = datetime.fromtimestamp(mktime(et)) + timedelta(days = 1)
        self.hour1 = newStart.hour
        self.hour2 = newEnd.hour
        self.day1 = newStart.day
        self.day2 = newEnd.day
        self.month1 = newStart.month
        self.month2 = newEnd.month
        self.year1 = newStart.year
        self.year2 = newEnd.year

        self.endDate = date.fromisoformat(self.formatISO(et.tm_year,et.tm_mon,et.tm_mday))
        self.endHour = et.tm_hour
        
        
    def setStartDate(self):
        st = time.strptime(self.startTime,"%Y/%m/%d/%H")
        self.startDate = date.fromisoformat(self.formatISO(st.tm_year,st.tm_mon, st.tm_mday))
        self.startHour = st.tm_hour    
        
    def checkDate(self,dateToCheck):
        isoDate = dateToCheck.split(" ")[0]
        hour = dateToCheck.split(" ")[1][0:2]
        newDate = date.fromisoformat(isoDate)
        if newDate == self.startDate and int(hour) == self.startHour:
            self.startHour = self.startHour+1
            if self.startHour == 24:
                self.startHour = 0
                self.startDate = self.startDate + timedelta(days =1)
            return True
        return False     
        
    def getMetarData(self,station):
        request_url = self.urlFront + "station={}".format(station) + self.urlMiddle + "year1={}&month1={}&day1={}&year2={}&month2={}&day2={}".format(self.year1,self.month1,self.day1,self.year2,self.month2,self.day2)+self.urlEnd
        response = request.urlopen(request_url)
        data = response.read().splitlines()
        prevD = [14]
        for line in range(1, len(data)):
            decodedData = data[line].decode().split(',')
            if(self.checkDate(decodedData[1])):
                self.compiledRows.append(prevD)
                
            if(self.startDate >= self.endDate and self.startHour > self.endHour):
                break
            prevD = data[line].decode().split(',')
            
     
args = sys.argv
processMetar(args[1], args[2]).run()
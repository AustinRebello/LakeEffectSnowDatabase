import sys
import json
import numpy as np
import time
import math
import urllib.request as request
from urllib.error import HTTPError
import re
import metpy.calc as mc
from metpy.units import units
from datetime import datetime

####################################################
#Original Code Author: nickl
#Repurposed code for grabbing BUFKIT and METARs data for a Lake Effect Snow Event Database for NWS CLEVELAND
#Lets get the data from iastate, thanks iastate!
#
url='https://mtarchive.geol.iastate.edu'
#Format is url/YYYY/MM/DD/bufkit/HH/rap
####################################################

class processBufkit:
    def __init__(self,startTime,endTime, lakeTemp):
        self.url = url
        self.startTime = startTime
        self.endTime = endTime
        self.hour = ""
        self.year = ""
        self.month = ""
        self.day = ""
        #self.stations = ["kcle"]
        self.stations = ["kcle","keri","kgkl","le1","le2"]
        self.cape = 0
        self.times=[]
        self.bufkitRows = []
        self.bulkShearValues = []
        self.compiledRows = []
        self.lkTmp = float(lakeTemp)

    def run(self):
        """Run it!"""
        self.setUpTimeRange()
        for station in self.stations:  
            self.getRAPData(station)
            self.getNAMData(station)
        jsonOutput = json.dumps(self.compiledRows)
        print(jsonOutput)
    
    def bulkShear(self,p,u,v):
        return mc.bulk_shear(p,u,v)

    #This gets a list of all the hours w/i the time range    
    def setUpTimeRange(self):
        """Get a list of all the hours w/i the provided time range"""
        
        st = time.strptime(self.startTime,"%Y/%m/%d/%H")
        startUTCBase = datetime(st.tm_year, st.tm_mon, st.tm_mday, st.tm_hour)
        stUnix = (startUTCBase - datetime(1970,1,1)).total_seconds()
        et = time.strptime(self.endTime,"%Y/%m/%d/%H")
        endUTCBase = datetime(et.tm_year, et.tm_mon, et.tm_mday, et.tm_hour)
        etUnix = (endUTCBase - datetime(1970,1,1)).total_seconds()
        t = stUnix
        while t < etUnix:
            self.times.append(t)
            t = t +3600

    def calculateExactPressureValue(self, pressure, pLowData, pHighData):
            exactData = ["","","","","","","","","",""]
            pressureDifference = float(pHighData[0]) - float(pLowData[0])
            pressureDifferenceToTarget = pressure - float(pLowData[0])
            ratioOfDifference = pressureDifferenceToTarget/pressureDifference
            for dataPoint in range(10):
                exactData[dataPoint] = str(round(float(pLowData[dataPoint])+(float(pHighData[dataPoint])-float(pLowData[dataPoint]))*ratioOfDifference,2))
            return exactData


    def calculateRelativeHumidity(self, temperature, dewPoint):
        tempE = 6.1094*math.e**((17.625*temperature)/(243.04+temperature))
        dewE = 6.1094*math.e**((17.625*dewPoint)/(243.04+dewPoint))
        relHum = round(100*(dewE/tempE),2)
        return str(relHum)
    
    def calculateRelativeHumidityIce(self, temperature, dewPoint):
        tempE = 6.1121*math.e**((22.587*temperature)/(273.64+temperature))
        dewE = 6.1121*math.e**((22.587*dewPoint)/(273.64+dewPoint))
        relHum = round(100*(dewE/tempE),2)
        return str(relHum)
    
    def compileRow(self, station, modelType, year, month, day, hour):
        rowBuild = []
        rowBuild.extend([modelType, station, (str(year)+"-"+str(month)+"-"+str(day)+" "+str(hour))])
        rowBuild.append(self.bufkitRows[0][5])
        rowBuild.append(self.bufkitRows[0][6])
        for i in range(3):
            currentTemp = self.bufkitRows[i+1][2]
            currentDew = self.bufkitRows[i+1][3]
            relativeHumidity = self.calculateRelativeHumidity(float(currentTemp), float(currentDew))
            relativeHumidityIce = self.calculateRelativeHumidityIce(float(currentTemp), float(currentDew))
            bS = self.bulkShearValues
            
            rowBuild.extend([currentTemp, currentDew, relativeHumidity, relativeHumidityIce])
            rowBuild.extend([self.bufkitRows[i+1][5],self.bufkitRows[i+1][6],self.bufkitRows[i+1][9]])
        rowBuild.append(self.cape)
        #   calc and append LI Cape
        #   calc and append LI NCape
        #   calc and append LI EQL
        rowBuild.extend([0,0,0])
        rowBuild.extend([round(bS[0].magnitude,2),round(bS[1],2),round(bS[2],2)])
        rowBuild.append(round(self.lkTmp - float(self.bufkitRows[2][2]),2)) #DeltaTemperature for Lake surface temp to 850mb temp 
        rowBuild.append(round(self.lkTmp - float(self.bufkitRows[3][2]),2)) #DeltaTemperature for Lake surface temp to 700mb temp 
        self.compiledRows.append(rowBuild)
        
    def collectBulkShear(self, Ps, Us, Vs):
        bs = self.bulkShear(Ps*units('hPa'),Us*units('knots'),Vs*units('knots'))
        bsU,bsV = bs
        bulkS = mc.wind_speed(bsU,bsV)
        uMean,vMean = np.average(Us),np.average(Vs)
        self.bulkShearValues.extend([bulkS, uMean, vMean])
      
    def queryDataNAM(self, modelType, hour, startingSTIM, endingSTIM, station):
        request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,hour,'nam',modelType,station)
        try:
            response = request.urlopen(request_url)
        except HTTPError as err:
            if station == 'kgkl':
                station = 'kgkj'
                request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,hour,'nam',modelType,station)
                response = request.urlopen(request_url)
                    
        data = response.read().splitlines()
        for stimSearch in range(startingSTIM, endingSTIM+1):
            stimFound = stimSearch*132+6
            stim = data[stimFound].decode('ascii').split(' ')[2]
            prevD = [10]
            found925 = False
            found850 = False
            found700 = False
            foundSurface = False
            self.bufkitRows = []
            self.bulkShearValues = []
            Us = []
            Vs = []
            Ps = []
            self.cape = 0
            for line in range(stimSearch*132+6,len(data)):
                if re.search("(((-\d+\.\d+.)|(\d+\.\d+.)){7}((\d+\.\d+)|(-\d+\.\d+)))",data[line].decode('ascii')):
                    d = (data[line].decode('ascii')+" "+data[line+1].decode('ascii')).split()
                    d2,s = d[5:7]
                    s = float(s) * units('knots')
                    d2 = float(d2) * units('deg')
                    u,v = mc.wind_components(s,d2)
                    Us.append(u.m)
                    Vs.append(v.m)
                    Ps.append(float(d[0]))
                    
                    if not foundSurface:
                        foundSurface = True
                        self.bufkitRows.append(d)
                        prevD = d
                    elif float(d[0]) < 925.0 and not found925:
                        truePressureData = self.calculateExactPressureValue(925, d, prevD)
                        found925 = True
                        self.bufkitRows.append(truePressureData)
                        prevD = d
                    elif float(d[0]) < 850.0 and not found850:
                        truePressureData = self.calculateExactPressureValue(850, d, prevD)
                        found850 = True
                        self.bufkitRows.append(truePressureData)
                        prevD = d
                    elif float(d[0]) < 700.0 and not found700:
                        truePressureData = self.calculateExactPressureValue(700, d, prevD)
                        found700 = True
                        self.bufkitRows.append(truePressureData)
                        self.collectBulkShear(Ps, Us, Vs)
                        
                        self.compileRow(station, "NAM", self.year, self.month, self.day, int(hour)+int(stim))
                        break
                    else:
                        prevD = d
                elif line == stimFound+3:
                    capeLine = data[line].decode('ascii')
                    splitLine = capeLine.split(" ")
                    self.cape = splitLine[-1]
                    
                if stim == endingSTIM and found700:
                    break
   
    def getNAMData(self, station):
        times = self.times
        ah = 0
        while ah < len(times):
            atime = time.strftime("%Y/%m/%d/%H", time.gmtime(times[ah]))
            self.year,self.month,self.day,self.hour = atime.split("/")
            endStim = len(times)-ah-1
            startStim = 0
            if(endStim<5):
                useValue = endStim
            else:
                useValue = 5
            if int(self.hour)>=0 and int(self.hour)<6:
                startStim = int(self.hour)-0
                self.queryDataNAM('nam','00', startStim, useValue, station)
            elif int(self.hour)>=6 and int(self.hour)<12:
                startStim = int(self.hour)-6
                self.queryDataNAM('namm','06', startStim, useValue, station)
            elif int(self.hour)>=12 and int(self.hour)<18:
                startStim = int(self.hour)-12
                self.queryDataNAM('nam','12', startStim, useValue, station)
            elif int(self.hour)>=18 and int(self.hour)<24:
                startStim = int(self.hour)-18
                self.queryDataNAM('namm','18', startStim, useValue, station)
            ah = ah + useValue - startStim + 1
                   
    def getRAPData(self,station):
        for ah in self.times:
            atime = time.strftime("%Y/%m/%d/%H", time.gmtime(ah))
            
            self.year,self.month,self.day,self.hour = atime.split("/")
            request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,self.hour,'rap','rap',station)
            try:
                response = request.urlopen(request_url)
            except HTTPError as err:
                if station == 'kgkl':
                    station = 'kgkj'
                    request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,self.hour,'rap','rap',station)
                    response = request.urlopen(request_url)
                    
            data = response.read().splitlines()
            prevD = [10]
            found925 = False
            found850 = False
            found700 = False
            foundSurface = False
            self.bufkitRows = []
            self.bulkShearValues = []
            Us = []
            Vs = []
            Ps = []
            self.cape = 0
            for line in range(0,len(data)):
                if re.search("(((-\d+\.\d+.)|(\d+\.\d+.)){7}((\d+\.\d+)|(-\d+\.\d+)))",data[line].decode('ascii')):
                    d = (data[line].decode('ascii')+" "+data[line+1].decode('ascii')).split()
                    d2,s = d[5:7]
                    s = float(s) * units('knots')
                    d2 = float(d2) * units('deg')
                    u,v = mc.wind_components(s,d2)
                    Us.append(u.m)
                    Vs.append(v.m)
                    Ps.append(float(d[0]))
                    
                    if not foundSurface:
                        foundSurface = True
                        self.bufkitRows.append(d)
                        prevD = d
                    elif float(d[0]) < 925.0 and not found925:
                        truePressureData = self.calculateExactPressureValue(925, d, prevD)
                        found925 = True
                        self.bufkitRows.append(truePressureData)
                        prevD = d
                    elif float(d[0]) < 850.0 and not found850:
                        truePressureData = self.calculateExactPressureValue(850, d, prevD)
                        found850 = True
                        self.bufkitRows.append(truePressureData)
                        prevD = d
                    elif float(d[0]) < 700.0 and not found700:
                        truePressureData = self.calculateExactPressureValue(700, d, prevD)
                        found700 = True
                        self.bufkitRows.append(truePressureData)
                        self.collectBulkShear(Ps, Us, Vs)
                        self.compileRow(station, "RAP", self.year, self.month, self.day, self.hour)
                        break
                    else:
                        prevD = d
                elif line == 9:
                    capeLine = data[line].decode('ascii')
                    splitLine = capeLine.split(" ")
                    self.cape = splitLine[-1]

args = sys.argv
processBufkit(args[1], args[2], args[3]).run()
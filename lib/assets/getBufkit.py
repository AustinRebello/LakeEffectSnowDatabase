
1 of 1,567
Pull request docs
Inbox

Austin Rebello - NOAA Affiliate
Attachments
12:01 PM (2 hours ago)
to me


2
 Attachments
  •  Scanned by Gmail

Austin Rebello - NOAA Affiliate
Attachments
2:13 PM (8 minutes ago)
to me



On Thu, Jul 27, 2023 at 12:00 PM Austin Rebello - NOAA Affiliate <austin.rebello@noaa.gov> wrote:


 One attachment
  •  Scanned by Gmail
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
#Current Code Author: Austin Rebello
#Repurposed code for grabbing BUFKIT data for a Lake Effect Snow Event Database for NWS CLEVELAND
#Bufkit data comes from Iowa State's archive
url='https://mtarchive.geol.iastate.edu'
#Format is url/YYYY/MM/DD/bufkit/HH/rap
####################################################

class processBufkit:
    #Initializes the class Object when the class is called at the bottom of the file
    def __init__(self,startTime,endTime, lakeTemp):
        self.url = url
        self.startTime = startTime
        self.endTime = endTime
        self.hour = ""
        self.year = ""
        self.month = ""
        self.day = ""
        #Bufkit sounding stations list
        self.stations = ["kcle","keri","kgkl","le1","le2"]
        self.cape = 0
        self.crosshair = False
        self.times=[]
        self.bufkitRows = []
        self.bulkShearValues = []
        self.compiledRows = []
        self.lkTmp = float(lakeTemp)

    def run(self):
        #Sets up the time range for the Bufkit data, and for each station, gets the NAM and RAP data before outputting to JSON
        self.setUpTimeRange()
        for station in self.stations:  
            self.getRAPData(station)
            self.getNAMData(station)
        jsonOutput = json.dumps(self.compiledRows)
        print(jsonOutput)
    
    
    #Calculates the bulk shear
    def bulkShear(self,p,u,v):
        return mc.bulk_shear(p,u,v)

    #This gets a list of all the hours w/i the time range, accounting for UTC, DST and leap years    
    def setUpTimeRange(self):
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

    #Given that the models rarely have exact pressure levels, linear extrapolation is used to approximate what
    #the values at a given pressure level would be
    def calculateExactPressureValue(self, pressure, pLowData, pHighData):
            exactData = ["","","","","","","","","",""]
            pressureDifference = float(pHighData[0]) - float(pLowData[0])
            pressureDifferenceToTarget = pressure - float(pLowData[0])
            ratioOfDifference = pressureDifferenceToTarget/pressureDifference
            for dataPoint in range(10):
                exactData[dataPoint] = str(round(float(pLowData[dataPoint])+(float(pHighData[dataPoint])-float(pLowData[dataPoint]))*ratioOfDifference,2))
            return exactData

    #Calculates relative humidity given temperature and dew point
    def calculateRelativeHumidity(self, temperature, dewPoint):
        tempExponent = ((17.625*temperature)/(243.04+temperature))
        if(tempExponent > 5 or tempExponent < -5):
            return("-9999")
        tempE = 6.1094*math.e**((17.625*temperature)/(243.04+temperature))
        dewE = 6.1094*math.e**((17.625*dewPoint)/(243.04+dewPoint))
        relHum = round(100*(dewE/tempE),2)
        return str(relHum)
    
    #Calculates relative humidity with respect to ice given temperature and dew point
    def calculateRelativeHumidityIce(self, temperature, dewPoint):
        tempE = 6.1121*math.e**((22.587*temperature)/(273.64+temperature))
        dewE = 6.1121*math.e**((22.587*dewPoint)/(273.64+dewPoint))
        relHum = round(100*(dewE/tempE),2)
        return str(relHum)
    
    #Accumulates all the data into one entry of a multi-dimensional array for JSON parsing
    def compileRow(self, station, modelType, year, month, day, hour, cross):
        rowBuild = []
        if(len(hour)<2):
            hour = "0"+hour
        rowBuild.extend([modelType, station, (str(year)+"-"+str(month)+"-"+str(day)+" "+hour)]) #Model Type, Station, Date
        rowBuild.append(self.bufkitRows[0][5]) #10 Meter Wind Direction
        rowBuild.append(self.bufkitRows[0][6]) #10 Meter Wind Speed
        #Aggregates the temperature, dewpoint, and bulk shear then calculates the relative humidity
        #and relative humidity with respect to ice for each pressure level before appending it to the final row
        for i in range(3):
            currentTemp = self.bufkitRows[i+1][2]
            currentDew = self.bufkitRows[i+1][3]
            relativeHumidity = self.calculateRelativeHumidity(float(currentTemp), float(currentDew))
            relativeHumidityIce = self.calculateRelativeHumidityIce(float(currentTemp), float(currentDew))
            bS = self.bulkShearValues
            
            rowBuild.extend([currentTemp, currentDew, relativeHumidity, relativeHumidityIce]) #Temp, DewP, RelHum, RelHumIce for each pressure level
            rowBuild.extend([self.bufkitRows[i+1][5],self.bufkitRows[i+1][6],self.bufkitRows[i+1][9]]) #Wind Speed, Wind Direction, Height for each pressure level
        rowBuild.append(self.cape) #Model Cape
        #   calc and append LI Cape
        #   calc and append LI NCape
        #   calc and append LI EQL
        rowBuild.extend([0,0,0]) #LI Cape, LI NCape and LI EQL
        rowBuild.extend([round(bS[0].magnitude,2),round(bS[1],2),round(bS[2],2)]) #Bulk Shear, BS U and BS V
        rowBuild.append(round(self.lkTmp - float(self.bufkitRows[2][2]),2)) #DeltaTemperature for Lake surface temp to 850mb temp 
        rowBuild.append(round(self.lkTmp - float(self.bufkitRows[3][2]),2)) #DeltaTemperature for Lake surface temp to 700mb temp 
        rowBuild.append(cross) #Crosshair signature
        self.compiledRows.append(rowBuild)
    
    #Collects and calculates the bulk shear values    
    def collectBulkShear(self, Ps, Us, Vs):
        bs = self.bulkShear(Ps*units('hPa'),Us*units('knots'),Vs*units('knots'))
        bsU,bsV = bs
        bulkS = mc.wind_speed(bsU,bsV)
        uMean,vMean = np.average(Us),np.average(Vs)
        self.bulkShearValues.extend([bulkS, uMean, vMean])
    
    def scrapeData(self, data, rangeOne, rangeTwo, station, modelName, modelHour, capeL):
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
        self.crosshair = False
            
        omegaData = [0,0,0]
        
        #Once the STIM is found, search that run for the model data
        for line in range(rangeOne, rangeTwo):
                
            #Searches for lines that match the individual pressure level data lines
            if re.search("(((-\d+\.\d+.)|(\d+\.\d+.)){7}((\d+\.\d+)|(-\d+\.\d+)))",data[line].decode('ascii')):
                    
                #Decodes the data and starts pulling in values
                d = (data[line].decode('ascii')+" "+data[line+1].decode('ascii')).split()
                d2,s = d[5:7]
                s = float(s) * units('knots')
                d2 = float(d2) * units('deg')
                u,v = mc.wind_components(s,d2)
                Us.append(u.m)
                Vs.append(v.m)
                Ps.append(float(d[0]))
                    
                #First line will always be the surface, grab data and set flag to true to skip this in future iterations
                if not foundSurface:
                    foundSurface = True
                    self.bufkitRows.append(d)
                    prevD = d
                        
                #Grabs data from both the pressure level above and below the 925mb Pressure Level
                elif float(d[0]) < 925.0 and not found925:
                    truePressureData = self.calculateExactPressureValue(925, d, prevD)
                    found925 = True
                    self.bufkitRows.append(truePressureData)
                    prevD = d
                        
                #Grabs data from both the pressure level above and below the 850mb Pressure Level
                elif float(d[0]) < 850.0 and not found850:
                    truePressureData = self.calculateExactPressureValue(850, d, prevD)
                    found850 = True
                    self.bufkitRows.append(truePressureData)
                    prevD = d
                        
                #Grabs data from both the pressure level above and below the 700mb Pressure Level
                elif float(d[0]) < 700.0 and not found700:
                    truePressureData = self.calculateExactPressureValue(700, d, prevD)
                    found700 = True
                    self.bufkitRows.append(truePressureData)
                    self.collectBulkShear(Ps, Us, Vs)
                        
                    #Calculates if the crosshair is present or not
                    if(float(d[7])<=omegaData[0] or omegaData[2]<80 or omegaData[1]>-12 or omegaData[1]<-18 or omegaData[0]>=0.0):
                        self.crosshair = False
                    else:
                        self.crosshair = True
                    
                    #Compiles the station, model and date data for the row
                    self.compileRow(station, modelName, self.year, self.month, self.day, modelHour, self.crosshair)
                    break
                else:
                    prevD = d
                    
                #Outside of finding data, keep track of the omega value, temperature, and humidity to calculate the presence of a crosshair
                if(float(d[7])<=omegaData[0]):
                    omegaData[0] = float(d[7])
                    omegaData[1] = float(d[1])
                    omegaData[2] = float(self.calculateRelativeHumidity(float(d[1]), float(d[2])))
                
            #Scrapes the CAPE value found at the top of each sounding      
            elif line == capeL:
                capeLine = data[line].decode('ascii')
                splitLine = capeLine.split(" ")
                self.cape = splitLine[-1]               
    
    #Function that handles opening the NAM URLs to scrape the data
    def queryDataNAM(self, modelType, hour, startingSTIM, endingSTIM, station):
        #Builds the URL
        request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,hour,'nam',modelType,station)
        
        #Corrects the link since GKL changed station codes in the past
        try:
            response = request.urlopen(request_url)
        except HTTPError as err:
            if station == 'kgkl':
                station = 'kgkj'
                request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,hour,'nam',modelType,station)
                try:
                    response = request.urlopen(request_url)
                except HTTPError as err:
                    return
            else:
                return
        
        #Splits the page into iterable lines        
        data = response.read().splitlines()
        
        #Loop that looks for the requested STIM times
        #STIM time would be the forecast hour needed since the NAM does 6 hour runs not hourly
        #So 14Z would be STIM 2 on the 12Z run
        #Each STIM line is always 132 lines apart
        for stimSearch in range(startingSTIM, startingSTIM+endingSTIM+1):
            stimFound = stimSearch*132+6
            stim = data[stimFound].decode('ascii').split(' ')[2]
            
            if station == "kgkj":
                station = "kgkl"
            
            #Scrapes and processes the data
            self.scrapeData(data, stimSearch*132+6, len(data), station, "NAM", str(int(hour)+int(stim)), stimFound+3)                          
   
   #Iterates over each time to get NAM data, sets up appropriate STIM values to search between for each link
   #Also formats each link depending on a 0/12Z run or a 6/18Z run since the links are different
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
                if(startStim + useValue > 5):
                    useValue = 5 - startStim
                self.queryDataNAM('nam','00', startStim, useValue, station)
            elif int(self.hour)>=6 and int(self.hour)<12:
                startStim = int(self.hour)-6
                if(startStim + useValue > 5):
                    useValue = 5 - startStim
                self.queryDataNAM('namm','06', startStim, useValue, station)
            elif int(self.hour)>=12 and int(self.hour)<18:
                startStim = int(self.hour)-12
                if(startStim + useValue > 5):
                    useValue = 5 - startStim
                self.queryDataNAM('nam','12', startStim, useValue, station)
            elif int(self.hour)>=18 and int(self.hour)<24:
                startStim = int(self.hour)-18
                if(startStim + useValue > 5):
                    useValue = 5 - startStim
                self.queryDataNAM('namm','18', startStim, useValue, station)
            ah = ah + useValue + 1

     #Function that handles opening the RAP URLs to scrape the data             
    def getRAPData(self,station):
        
        #Iterates through each time since RAP is an hourly model
        for ah in self.times:
            atime = time.strftime("%Y/%m/%d/%H", time.gmtime(ah))
            model = 'rap'
            self.year,self.month,self.day,self.hour = atime.split("/")
            request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,self.hour,model,model,station)
            response = ''
            try:
                response = request.urlopen(request_url)
            except HTTPError as err:
                if station == 'kgkl':
                    station = 'kgkj'
                    try:
                        request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,self.hour,model,model,station)
                        response = request.urlopen(request_url)
                    except HTTPError as err:
                        model = 'ruc'
                        request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,self.hour,model,model,station)
                        try:
                            response = request.urlopen(request_url)
                        except HTTPError as err:
                            break
                else:
                    model = 'ruc'
                    request_url = self.url + "/{}/{}/{}/bufkit/{}/{}/{}_{}.buf".format(self.year,self.month,self.day,self.hour,model,model,station)
                    try:
                        response = request.urlopen(request_url)
                    except HTTPError as err:
                        break
            if response == '':
                break
            #Splits the page into iterable lines and initializes the flags and arrays used for each hourly sounding      
            data = response.read().splitlines()
            
            if station == "kgkj":
                station = "kgkl"
            
            #Scrapes and processes the data
            self.scrapeData(data, 0, len(data), station, "RAP", self.hour, 9)

args = sys.argv
processBufkit(args[1], args[2], args[3]).run()

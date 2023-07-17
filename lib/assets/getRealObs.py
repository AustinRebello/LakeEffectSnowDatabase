import sys
import json
import time
import urllib.request as request
from urllib.error import HTTPError
import datetime

class processRealObservations:
    #Initializes the class Object when the class is called at the bottom of the file
    def __init__(self, startDate, endDate):
        self.url = "https://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR="
        self.startDate = startDate
        self.endDate = endDate
        self.sites = ["72528", "72632"]
        self.compiledRows = []
        self.dates = []
    
    #Runs the collection of real observations, calls the required commands, formats the response into JSON, and prints it for response collection
    def run(self):
        self.getDates()
        for site in self.sites:
            self.getSurfaceObs(site)
        
        jsonOutput = json.dumps(self.compiledRows)
        print(jsonOutput)
    
    #Retrieves the surface observation from University of Wyoming's sounding archive
    def getSurfaceObs(self, station):
        #Iterates over each date
        for date in self.dates:
            #Generates the URL based off of the date
            url = self.url + str(date[0])+"&MONTH="+date[1]+"&FROM="+date[2]+"&TO="+date[2]+"&STNM="+station
            
            #Initializes the pressure level arrays, surface, 925mb, 850mb, and 700mb, and the validData flag
            sur = []
            ntf = []
            eft = []
            shd = []
            validData = False
            
            #Tries to scrape the data from the site, skips the date's data if the site does not respond
            try:
                response = request.urlopen(url)
            except HTTPError as err:
                continue
            
            #Splits the entire HTML response into iterable lines, then iterates over each line
            data = response.read().splitlines()
            for line in data:
                lineData = line.decode('utf-8')
                #print(lineData)
                #If the HTML file contains a line with a pressure level of 1000, it is a valid link and can be collected
                if(station in lineData):
                    stat = lineData[10:13]
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
            
            #If the data was valid, it can be appended to the list of valid data for printing
            if(validData):
                self.compiledRows.append([stat, str(date[0])+"/"+str(date[1])+"/"+date[2][0:2]+"/"+date[2][2:], 
                                      sur[0], sur[1], sur[2], sur[3], sur[4], sur[5], sur[6],
                                      ntf[0], ntf[1], ntf[2], ntf[3], ntf[4], ntf[5], ntf[6],
                                      eft[0], eft[1], eft[2], eft[3], eft[4], eft[5], eft[6],
                                      shd[0], shd[1], shd[2], shd[3], shd[4], shd[5], shd[6]])
    
    #Takes in the start and end date, and generates 12hr intervals to iterate over and generate links to retrieve data from     
    def getDates(self):
        
        #Formats the date information for proper iteration
        sd = time.strptime(self.startDate,"%Y/%m/%d/%H")
        ed = time.strptime(self.endDate,"%Y/%m/%d/%H")
        
        newSD = datetime.datetime(sd.tm_year, sd.tm_mon, sd.tm_mday, 0)
        newED = datetime.datetime(ed.tm_year, ed.tm_mon, ed.tm_mday, 0)
        newED = newED + datetime.timedelta(days = 1)

        #Generates a new date every 12 hours until start date equals the end date
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
    
    #Takes the entire line of data containing the pertinent information, splits the line into each component and returns only the necessary ones
    def processLine(self, line):
        line = line.split(" ")
        while "" in line:
            line.remove("")
            
        #Pressure Height Temp DP RelHum WindDir WindSp
        return([line[0], line[2], line[3], line[4], line[6], line[7], line[1]])

args = sys.argv
processRealObservations(args[1], args[2]).run()
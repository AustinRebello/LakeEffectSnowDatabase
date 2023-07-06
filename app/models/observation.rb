class Observation < ApplicationRecord
    belongs_to :lake_effect_snow_event
    require 'csv'

    def self.python(output, event_id)
        newOutput = JSON.parse(output)
        newOutput.each do |row|
            newOb = Observation.new
            newOb.site = row[0]
            newOb.date = row[1]
            newOb.surPressure = row[2]
            newOb.surTemperature = row[3]
            newOb.surDewPoint = row[4]
            newOb.surHumidity = row[5]
            newOb.surWindDirection = row[6]
            newOb.surWindSpeed = row[7]
            newOb.surHeight = row[8]
            newOb.ninePressure = row[9]
            newOb.nineTemperature = row[10]
            newOb.nineDewPoint = row[11]
            newOb.nineHumidity = row[12]
            newOb.nineWindDirection = row[13]
            newOb.nineWindSpeed = row[14]
            newOb.nineHeight = row[15]
            newOb.eightPressure = row[16]
            newOb.eightTemperature = row[17]
            newOb.eightDewPoint = row[18]
            newOb.eightHumidity = row[19]
            newOb.eightWindDirection = row[20]
            newOb.eightWindSpeed = row[21]
            newOb.eightHeight = row[22]
            newOb.sevenPressure = row[23]
            newOb.sevenTemperature = row[24]
            newOb.sevenDewPoint = row[25]
            newOb.sevenHumidity = row[26]
            newOb.sevenWindDirection = row[27]
            newOb.sevenWindSpeed = row[28]
            newOb.sevenHeight = row[29]
            newOb.lake_effect_snow_event_id = event_id
            newOb.save
        end
    end

    def self.download(event_id)
        reports = Observation.where(lake_effect_snow_event_id: event_id)
        CSV.generate do |csv|
           csv << column_names
           reports.each do |report|
               csv<< report.attributes.values_at(*column_names)
           end
       end
     end

end

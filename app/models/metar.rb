class Metar < ApplicationRecord
  belongs_to :lake_effect_snow_event

  def self.python(output, event_id)
    newOutput = JSON.parse(output)
    newOutput.each do |row|
      newMetar = Metar.new
      newMetar.site = row[0]
      newMetar.observationTime = row[1]
      if row[2]=="M" then newMetar.temperature = 9999.0 else newMetar.temperature = row[2] end
      if row[3]=="M" then newMetar.dewPoint = 9999.0 else newMetar.dewPoint= row[3] end
      if row[4]=="M" then newMetar.humidity = 9999.0 else newMetar.humidity = row[4] end
      if row[5]=="M" then newMetar.windDirection = 9999 else newMetar.windDirection = row[5] end
      if row[6]=="M" then newMetar.windSpeed = 9999 else newMetar.windSpeed = row[6] end
      if row[7]=="M" then newMetar.meanLevelSeaPressure = 9999.0 else newMetar.meanLevelSeaPressure = row[7] end
      if row[8]=="M" then newMetar.visibility = 9999.0 else newMetar.visibility = row[8] end
      if row[9]=="M" then newMetar.windGust = 9999 else newMetar.windGust = row[9] end
      newMetar.presentWX = row[10]
      if row[11]=="M" then newMetar.peakWindGust = 9999 else newMetar.peakWindGust = row[11] end
      if row[12]=="M" then newMetar.peakWindDirection = 9999 else newMetar.peakWindDirection = row[12] end
      newMetar.peakWindTime = row[13]
      newMetar.lake_effect_snow_event_id = event_id
      newMetar.save
    end
  end

  def self.downloadBUF(event_id)
     metars = Metar.where(lake_effect_snow_event_id: event_id)
    CSV.generate do |csv|
        csv << column_names
        metars.each do |metar|
            csv<< metar.attributes.values_at(*column_names)
        end
    end
  end

end
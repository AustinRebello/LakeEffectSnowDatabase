class Bufkit < ActiveRecord::Base
  belongs_to :lake_effect_snow_event
  require 'json'

  def self.downloadBUF(event_id, modelType)
    bufkits = Bufkit.where(lake_effect_snow_event_id: event_id).where(modelType: modelType)
    CSV.generate do |csv|
        csv << column_names
        bufkits.each do |bufkit|
            csv<<bufkit.attributes.values_at(*column_names)
        end
    end
  end
  
  def self.handleDate(date, time)
    month = date.month.to_s
    if month.length == 1
      month = "0"+month
    end
    year = date.year.to_s
    day = date.day.to_s
    if day.length == 1
      day = "0"+day
    end
    hour = time.to_s
    if hour.length ==1
      hour = "0"+hour
    end
    return year+"/"+month+"/"+day+"/"+hour
  end
  
  def self.python(output, event_id)
    newOutput = JSON.parse(output)
    newOutput.each do |row|
      newbufkit = Bufkit.new
      newbufkit.modelType = row[0]
      newbufkit.station = row[1]
      newbufkit.date = row[2]
      newbufkit.tenMeterWindDirection = row[3].to_i
      newbufkit.tenMeterWindSpeed = row[4].to_i
      newbufkit.lowTemp = row[5].to_f
      newbufkit.lowDew = row[6].to_f
      newbufkit.lowHumidity = row[7].to_f
      newbufkit.lowHumidityIce = row[8].to_f
      newbufkit.lowWindDirection = row[9].to_i
      newbufkit.lowWindSpeed = row[10].to_i
      newbufkit.lowHeight = row[11].to_i
      newbufkit.medTemp = row[12].to_f
      newbufkit.medDew = row[13].to_f
      newbufkit.medHumidity = row[14].to_f
      newbufkit.medHumidityIce = row[15].to_f
      newbufkit.medWindDirection = row[16].to_i
      newbufkit.medWindSpeed = row[17].to_i
      newbufkit.medHeight = row[18].to_i
      newbufkit.highTemp = row[19].to_f
      newbufkit.highDew = row[20].to_f
      newbufkit.highHumidity = row[21].to_f
      newbufkit.highHumidityIce = row[22].to_f
      newbufkit.highWindDirection = row[23].to_i
      newbufkit.highWindSpeed = row[24].to_i
      newbufkit.highHeight = row[25].to_i
      newbufkit.modelCape = row[26].to_i
      newbufkit.lakeEffectCape = row[27]
      newbufkit.lakeEffectNCape = row[28]
      newbufkit.lakeEffectEQL = row[29]
      newbufkit.bulkShear = row[30]
      newbufkit.bulkShearU = row[31]
      newbufkit.bulkShearV = row[32]
      newbufkit.lowDeltaT = row[33]
      newbufkit.highDeltaT = row[34]
      newbufkit.lake_effect_snow_event_id = event_id
      newbufkit.save
    end
  end
end

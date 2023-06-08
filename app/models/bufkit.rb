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
      newbufkit.year = row[2].to_i
      newbufkit.month = row[3].to_i
      newbufkit.day = row[4].to_i
      newbufkit.hour = row[5].to_i
      newbufkit.tenMeterWindDirection = row[6].to_i
      newbufkit.tenMeterWindSpeed = row[7].to_i
      newbufkit.lowTemp = row[8].to_f
      newbufkit.lowDew = row[9].to_f
      newbufkit.lowHumidity = row[10].to_f
      newbufkit.lowHumidityIce = row[11].to_f
      newbufkit.lowWindDirection = row[12].to_i
      newbufkit.lowWindSpeed = row[13].to_i
      newbufkit.lowHeight = row[14].to_i
      newbufkit.medTemp = row[15].to_f
      newbufkit.medDew = row[16].to_f
      newbufkit.medHumidity = row[17].to_f
      newbufkit.medHumidityIce = row[18].to_f
      newbufkit.medWindDirection = row[19].to_i
      newbufkit.medWindSpeed = row[20].to_i
      newbufkit.medHeight = row[21].to_i
      newbufkit.highTemp = row[22].to_f
      newbufkit.highDew = row[23].to_f
      newbufkit.highHumidity = row[24].to_f
      newbufkit.highHumidityIce = row[25].to_f
      newbufkit.highWindDirection = row[26].to_i
      newbufkit.highWindSpeed = row[27].to_i
      newbufkit.highHeight = row[28].to_i
      newbufkit.modelCape = row[29].to_i
      newbufkit.lakeEffectCape = row[30]
      newbufkit.lakeEffectNCape = row[31]
      newbufkit.lakeEffectEQL = row[32]
      newbufkit.bulkShear = row[33]
      newbufkit.bulkShearU = row[34]
      newbufkit.bulkShearV = row[35]
      newbufkit.lowDeltaT = row[36]
      newbufkit.highDeltaT = row[37]
      newbufkit.lake_effect_snow_event_id = event_id
      newbufkit.save
    end
  end
end

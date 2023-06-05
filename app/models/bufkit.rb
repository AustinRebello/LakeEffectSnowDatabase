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
    year = date.cwyear.to_s
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
      newbufkit.lowTemp = row[8].to_i
      newbufkit.lowDew = row[9].to_i
      newbufkit.lowHumidity = row[10].to_i
      newbufkit.lowWindDirection = row[11].to_i
      newbufkit.lowWindSpeed = row[12].to_i
      newbufkit.lowHeight = row[13].to_i
      newbufkit.medTemp = row[14].to_i
      newbufkit.medDew = row[15].to_i
      newbufkit.medHumidity = row[16].to_i
      newbufkit.medWindDirection = row[17].to_i
      newbufkit.medWindSpeed = row[18].to_i
      newbufkit.medHeight = row[19].to_i
      newbufkit.highTemp = row[20].to_i
      newbufkit.highDew = row[21].to_i
      newbufkit.highHumidity = row[22].to_i
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

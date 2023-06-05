class Metar < ApplicationRecord
  belongs_to :lake_effect_snow_event

  def self.python(output, event_id)
    newOutput = JSON.parse(output)
    newOutput.each do |row|
      #newMetar= Metar.new
      #newMetar.site = row[0]
      #newMetar.observationTime = row[1]
      if row[2]=="M" then puts(9999) else puts(row[2]) end#newMetar.temperature = 9999

      #puts(row)
      #newMetar.save
    end
  end
end
#create_table "metars", force: :cascade do |t|
 # t.string "site"
  #t.string "observationTime"
  #t.float "temperature"
  #t.float "dewPoint"
  #t.float "humidity"
  #t.integer "windDirection"
  #t.integer "windSpeed"
  #t.float "meanLevelSeaPressure"
  #t.float "visibility"
  #t.integer "windGust"
  #t.string "presentWX"
  #t.integer "peakWindGust"
  #t.integer "peakWindDirection"
  #t.string "peakWindTime"
  #t.integer "lake_effect_snow_event_id"
  #t.datetime "created_at", null: false
  #t.datetime "updated_at", null: false
#end
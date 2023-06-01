class SnowReport < ApplicationRecord
  belongs_to :lake_effect_snow_event
  require 'csv'


  def self.import(file,event_ID)
    csv_text = File.read(file.path)
    csv = CSV.parse(csv_text)
    rowCount = 0
    csv.each do |row|
      if rowCount==0
        rowCount = rowCount+1
      else
        newReport=SnowReport.new
        newReport.lake_effect_snow_event_id=event_ID
        newReport.lastName = row[0]
        newReport.city = row[1]
        newReport.latitude = row[2]
        newReport.longitude = row[3]
        newReport.stormTotal = row[4]
        newReport.save
      
      end
    end
  end
end

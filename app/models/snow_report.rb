class SnowReport < ApplicationRecord
  belongs_to :lake_effect_snow_event
  require 'csv'


  def self.import(file,event_ID)
    csv_text = File.read(file.path)
    csv = CSV.parse(csv_text)
    rowCount = 0
    csv.each do |row|
      if rowCount<1
        if !(row[0]=='Last Name' && row[1]=='City' && row[2]=='Lat' && row[3]=='Lon')
          return 1
        end
        
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
      rowCount = rowCount + 1
    end
    return 0
  end

  def self.download(event_id)
    reports = SnowReport.where(lake_effect_snow_event_id: event_id)
    CSV.generate do |csv|
       csv << column_names
       reports.each do |report|
           csv<< report.attributes.values_at(*column_names)
       end
   end
 end

end

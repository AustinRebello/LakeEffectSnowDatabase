json.extract! snow_report, :id, :lastName, :city, :latitude, :longitude, :stormTotal, :lakeEffectSnowEvent_id, :created_at, :updated_at
json.url snow_report_url(snow_report, format: :json)

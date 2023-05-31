json.extract! metar, :id, :site, :observationTime, :temperature, :dewPoint, :humidity, :windDirection, :windSpeed, :meanLevelSeaPressure, :visibility, :windGust, :presentWX, :peakWindGust, :peakWindDirection, :peakWindTime, :lakeEffectSnowEvent_id, :created_at, :updated_at
json.url metar_url(metar, format: :json)

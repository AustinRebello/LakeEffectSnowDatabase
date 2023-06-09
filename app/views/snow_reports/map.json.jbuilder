json.array! @reports do |report|
    json.lat report.latitude
    json.lng report.longitude
    json.title report.stormTotal
    json.content SnowReport.render(partial: 'snow_reports/snow_report', locals: { snowReport: report }, format: :html).squish
  end
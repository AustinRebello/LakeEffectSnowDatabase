require "application_system_test_case"

class MetarsTest < ApplicationSystemTestCase
  setup do
    @metar = metars(:one)
  end

  test "visiting the index" do
    visit metars_url
    assert_selector "h1", text: "Metars"
  end

  test "should create metar" do
    visit metars_url
    click_on "New metar"

    fill_in "Dewpoint", with: @metar.dewPoint
    fill_in "Humidity", with: @metar.humidity
    fill_in "Lakeeffectsnowevent", with: @metar.lakeEffectSnowEvent_id
    fill_in "Meanlevelseapressure", with: @metar.meanLevelSeaPressure
    fill_in "Observationtime", with: @metar.observationTime
    fill_in "Peakwinddirection", with: @metar.peakWindDirection
    fill_in "Peakwindgust", with: @metar.peakWindGust
    fill_in "Peakwindtime", with: @metar.peakWindTime
    fill_in "Presentwx", with: @metar.presentWX
    fill_in "Site", with: @metar.site
    fill_in "Temperature", with: @metar.temperature
    fill_in "Visibility", with: @metar.visibility
    fill_in "Winddirection", with: @metar.windDirection
    fill_in "Windgust", with: @metar.windGust
    fill_in "Windspeed", with: @metar.windSpeed
    click_on "Create Metar"

    assert_text "Metar was successfully created"
    click_on "Back"
  end

  test "should update Metar" do
    visit metar_url(@metar)
    click_on "Edit this metar", match: :first

    fill_in "Dewpoint", with: @metar.dewPoint
    fill_in "Humidity", with: @metar.humidity
    fill_in "Lakeeffectsnowevent", with: @metar.lakeEffectSnowEvent_id
    fill_in "Meanlevelseapressure", with: @metar.meanLevelSeaPressure
    fill_in "Observationtime", with: @metar.observationTime
    fill_in "Peakwinddirection", with: @metar.peakWindDirection
    fill_in "Peakwindgust", with: @metar.peakWindGust
    fill_in "Peakwindtime", with: @metar.peakWindTime
    fill_in "Presentwx", with: @metar.presentWX
    fill_in "Site", with: @metar.site
    fill_in "Temperature", with: @metar.temperature
    fill_in "Visibility", with: @metar.visibility
    fill_in "Winddirection", with: @metar.windDirection
    fill_in "Windgust", with: @metar.windGust
    fill_in "Windspeed", with: @metar.windSpeed
    click_on "Update Metar"

    assert_text "Metar was successfully updated"
    click_on "Back"
  end

  test "should destroy Metar" do
    visit metar_url(@metar)
    click_on "Destroy this metar", match: :first

    assert_text "Metar was successfully destroyed"
  end
end

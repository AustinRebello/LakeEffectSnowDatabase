require "application_system_test_case"

class ObservationsTest < ApplicationSystemTestCase
  setup do
    @observation = observations(:one)
  end

  test "visiting the index" do
    visit observations_url
    assert_selector "h1", text: "Observations"
  end

  test "should create observation" do
    visit observations_url
    click_on "New observation"

    fill_in "Date", with: @observation.date
    fill_in "Eightdewpoint", with: @observation.eightDewPoint
    fill_in "Eightheight", with: @observation.eightHeight
    fill_in "Eighthumidity", with: @observation.eightHumidity
    fill_in "Eightpressure", with: @observation.eightPressure
    fill_in "Eighttemperature", with: @observation.eightTemperature
    fill_in "Eightwinddirection", with: @observation.eightWindDirection
    fill_in "Eightwindspeed", with: @observation.eightWindSpeed
    fill_in "Lake effect snow event", with: @observation.lake_effect_snow_event_id
    fill_in "Ninedewpoint", with: @observation.nineDewPoint
    fill_in "Nineheight", with: @observation.nineHeight
    fill_in "Ninehumidity", with: @observation.nineHumidity
    fill_in "Ninepressure", with: @observation.ninePressure
    fill_in "Ninetemperature", with: @observation.nineTemperature
    fill_in "Ninewinddirection", with: @observation.nineWindDirection
    fill_in "Ninewindspeed", with: @observation.nineWindSpeed
    fill_in "Sevendewpoint", with: @observation.sevenDewPoint
    fill_in "Sevenheight", with: @observation.sevenHeight
    fill_in "Sevenhumidity", with: @observation.sevenHumidity
    fill_in "Sevenpressure", with: @observation.sevenPressure
    fill_in "Seventemperature", with: @observation.sevenTemperature
    fill_in "Sevenwinddirection", with: @observation.sevenWindDirection
    fill_in "Sevenwindspeed", with: @observation.sevenWindSpeed
    fill_in "Site", with: @observation.site
    fill_in "Surdewpoint", with: @observation.surDewPoint
    fill_in "Surheight", with: @observation.surHeight
    fill_in "Surhumidity", with: @observation.surHumidity
    fill_in "Surpressure", with: @observation.surPressure
    fill_in "Surtemperature", with: @observation.surTemperature
    fill_in "Surwinddirection", with: @observation.surWindDirection
    fill_in "Surwindspeed", with: @observation.surWindSpeed
    click_on "Create Observation"

    assert_text "Observation was successfully created"
    click_on "Back"
  end

  test "should update Observation" do
    visit observation_url(@observation)
    click_on "Edit this observation", match: :first

    fill_in "Date", with: @observation.date
    fill_in "Eightdewpoint", with: @observation.eightDewPoint
    fill_in "Eightheight", with: @observation.eightHeight
    fill_in "Eighthumidity", with: @observation.eightHumidity
    fill_in "Eightpressure", with: @observation.eightPressure
    fill_in "Eighttemperature", with: @observation.eightTemperature
    fill_in "Eightwinddirection", with: @observation.eightWindDirection
    fill_in "Eightwindspeed", with: @observation.eightWindSpeed
    fill_in "Lake effect snow event", with: @observation.lake_effect_snow_event_id
    fill_in "Ninedewpoint", with: @observation.nineDewPoint
    fill_in "Nineheight", with: @observation.nineHeight
    fill_in "Ninehumidity", with: @observation.nineHumidity
    fill_in "Ninepressure", with: @observation.ninePressure
    fill_in "Ninetemperature", with: @observation.nineTemperature
    fill_in "Ninewinddirection", with: @observation.nineWindDirection
    fill_in "Ninewindspeed", with: @observation.nineWindSpeed
    fill_in "Sevendewpoint", with: @observation.sevenDewPoint
    fill_in "Sevenheight", with: @observation.sevenHeight
    fill_in "Sevenhumidity", with: @observation.sevenHumidity
    fill_in "Sevenpressure", with: @observation.sevenPressure
    fill_in "Seventemperature", with: @observation.sevenTemperature
    fill_in "Sevenwinddirection", with: @observation.sevenWindDirection
    fill_in "Sevenwindspeed", with: @observation.sevenWindSpeed
    fill_in "Site", with: @observation.site
    fill_in "Surdewpoint", with: @observation.surDewPoint
    fill_in "Surheight", with: @observation.surHeight
    fill_in "Surhumidity", with: @observation.surHumidity
    fill_in "Surpressure", with: @observation.surPressure
    fill_in "Surtemperature", with: @observation.surTemperature
    fill_in "Surwinddirection", with: @observation.surWindDirection
    fill_in "Surwindspeed", with: @observation.surWindSpeed
    click_on "Update Observation"

    assert_text "Observation was successfully updated"
    click_on "Back"
  end

  test "should destroy Observation" do
    visit observation_url(@observation)
    click_on "Destroy this observation", match: :first

    assert_text "Observation was successfully destroyed"
  end
end

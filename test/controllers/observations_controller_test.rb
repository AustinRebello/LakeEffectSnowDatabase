require "test_helper"

class ObservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @observation = observations(:one)
  end

  test "should get index" do
    get observations_url
    assert_response :success
  end

  test "should get new" do
    get new_observation_url
    assert_response :success
  end

  test "should create observation" do
    assert_difference("Observation.count") do
      post observations_url, params: { observation: { date: @observation.date, eightDewPoint: @observation.eightDewPoint, eightHeight: @observation.eightHeight, eightHumidity: @observation.eightHumidity, eightPressure: @observation.eightPressure, eightTemperature: @observation.eightTemperature, eightWindDirection: @observation.eightWindDirection, eightWindSpeed: @observation.eightWindSpeed, lake_effect_snow_event_id: @observation.lake_effect_snow_event_id, nineDewPoint: @observation.nineDewPoint, nineHeight: @observation.nineHeight, nineHumidity: @observation.nineHumidity, ninePressure: @observation.ninePressure, nineTemperature: @observation.nineTemperature, nineWindDirection: @observation.nineWindDirection, nineWindSpeed: @observation.nineWindSpeed, sevenDewPoint: @observation.sevenDewPoint, sevenHeight: @observation.sevenHeight, sevenHumidity: @observation.sevenHumidity, sevenPressure: @observation.sevenPressure, sevenTemperature: @observation.sevenTemperature, sevenWindDirection: @observation.sevenWindDirection, sevenWindSpeed: @observation.sevenWindSpeed, site: @observation.site, surDewPoint: @observation.surDewPoint, surHeight: @observation.surHeight, surHumidity: @observation.surHumidity, surPressure: @observation.surPressure, surTemperature: @observation.surTemperature, surWindDirection: @observation.surWindDirection, surWindSpeed: @observation.surWindSpeed } }
    end

    assert_redirected_to observation_url(Observation.last)
  end

  test "should show observation" do
    get observation_url(@observation)
    assert_response :success
  end

  test "should get edit" do
    get edit_observation_url(@observation)
    assert_response :success
  end

  test "should update observation" do
    patch observation_url(@observation), params: { observation: { date: @observation.date, eightDewPoint: @observation.eightDewPoint, eightHeight: @observation.eightHeight, eightHumidity: @observation.eightHumidity, eightPressure: @observation.eightPressure, eightTemperature: @observation.eightTemperature, eightWindDirection: @observation.eightWindDirection, eightWindSpeed: @observation.eightWindSpeed, lake_effect_snow_event_id: @observation.lake_effect_snow_event_id, nineDewPoint: @observation.nineDewPoint, nineHeight: @observation.nineHeight, nineHumidity: @observation.nineHumidity, ninePressure: @observation.ninePressure, nineTemperature: @observation.nineTemperature, nineWindDirection: @observation.nineWindDirection, nineWindSpeed: @observation.nineWindSpeed, sevenDewPoint: @observation.sevenDewPoint, sevenHeight: @observation.sevenHeight, sevenHumidity: @observation.sevenHumidity, sevenPressure: @observation.sevenPressure, sevenTemperature: @observation.sevenTemperature, sevenWindDirection: @observation.sevenWindDirection, sevenWindSpeed: @observation.sevenWindSpeed, site: @observation.site, surDewPoint: @observation.surDewPoint, surHeight: @observation.surHeight, surHumidity: @observation.surHumidity, surPressure: @observation.surPressure, surTemperature: @observation.surTemperature, surWindDirection: @observation.surWindDirection, surWindSpeed: @observation.surWindSpeed } }
    assert_redirected_to observation_url(@observation)
  end

  test "should destroy observation" do
    assert_difference("Observation.count", -1) do
      delete observation_url(@observation)
    end

    assert_redirected_to observations_url
  end
end

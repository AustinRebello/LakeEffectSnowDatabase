require "test_helper"

class MetarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metar = metars(:one)
  end

  test "should get index" do
    get metars_url
    assert_response :success
  end

  test "should get new" do
    get new_metar_url
    assert_response :success
  end

  test "should create metar" do
    assert_difference("Metar.count") do
      post metars_url, params: { metar: { dewPoint: @metar.dewPoint, humidity: @metar.humidity, lakeEffectSnowEvent_id: @metar.lakeEffectSnowEvent_id, meanLevelSeaPressure: @metar.meanLevelSeaPressure, observationTime: @metar.observationTime, peakWindDirection: @metar.peakWindDirection, peakWindGust: @metar.peakWindGust, peakWindTime: @metar.peakWindTime, presentWX: @metar.presentWX, site: @metar.site, temperature: @metar.temperature, visibility: @metar.visibility, windDirection: @metar.windDirection, windGust: @metar.windGust, windSpeed: @metar.windSpeed } }
    end

    assert_redirected_to metar_url(Metar.last)
  end

  test "should show metar" do
    get metar_url(@metar)
    assert_response :success
  end

  test "should get edit" do
    get edit_metar_url(@metar)
    assert_response :success
  end

  test "should update metar" do
    patch metar_url(@metar), params: { metar: { dewPoint: @metar.dewPoint, humidity: @metar.humidity, lakeEffectSnowEvent_id: @metar.lakeEffectSnowEvent_id, meanLevelSeaPressure: @metar.meanLevelSeaPressure, observationTime: @metar.observationTime, peakWindDirection: @metar.peakWindDirection, peakWindGust: @metar.peakWindGust, peakWindTime: @metar.peakWindTime, presentWX: @metar.presentWX, site: @metar.site, temperature: @metar.temperature, visibility: @metar.visibility, windDirection: @metar.windDirection, windGust: @metar.windGust, windSpeed: @metar.windSpeed } }
    assert_redirected_to metar_url(@metar)
  end

  test "should destroy metar" do
    assert_difference("Metar.count", -1) do
      delete metar_url(@metar)
    end

    assert_redirected_to metars_url
  end
end

require "test_helper"

class BufkitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bufkit = bufkits(:one)
  end

  test "should get index" do
    get bufkits_url
    assert_response :success
  end

  test "should get new" do
    get new_bufkit_url
    assert_response :success
  end

  test "should create bufkit" do
    assert_difference("Bufkit.count") do
      post bufkits_url, params: { bufkit: { highDew: @bufkit.highDew, highHeight: @bufkit.highHeight, highHumidity: @bufkit.highHumidity, highTemp: @bufkit.highTemp, highWindDirection: @bufkit.highWindDirection, highWindSpeed: @bufkit.highWindSpeed, lakeEffectCape: @bufkit.lakeEffectCape, lakeEffectEQL: @bufkit.lakeEffectEQL, lakeEffectNCape: @bufkit.lakeEffectNCape, lakeEffectSnowEvent_id: @bufkit.lakeEffectSnowEvent_id, lowDew: @bufkit.lowDew, lowHeight: @bufkit.lowHeight, lowHumidity: @bufkit.lowHumidity, lowTemp: @bufkit.lowTemp, lowWindDirection: @bufkit.lowWindDirection, lowWindSpeed: @bufkit.lowWindSpeed, medDew: @bufkit.medDew, medHeight: @bufkit.medHeight, medHumidity: @bufkit.medHumidity, medTemp: @bufkit.medTemp, medWindDirection: @bufkit.medWindDirection, medWindSpeed: @bufkit.medWindSpeed, modelCape: @bufkit.modelCape, modelType: @bufkit.modelType, tenMeterWindDirection: @bufkit.tenMeterWindDirection, tenMeterWindSpeed: @bufkit.tenMeterWindSpeed } }
    end

    assert_redirected_to bufkit_url(Bufkit.last)
  end

  test "should show bufkit" do
    get bufkit_url(@bufkit)
    assert_response :success
  end

  test "should get edit" do
    get edit_bufkit_url(@bufkit)
    assert_response :success
  end

  test "should update bufkit" do
    patch bufkit_url(@bufkit), params: { bufkit: { highDew: @bufkit.highDew, highHeight: @bufkit.highHeight, highHumidity: @bufkit.highHumidity, highTemp: @bufkit.highTemp, highWindDirection: @bufkit.highWindDirection, highWindSpeed: @bufkit.highWindSpeed, lakeEffectCape: @bufkit.lakeEffectCape, lakeEffectEQL: @bufkit.lakeEffectEQL, lakeEffectNCape: @bufkit.lakeEffectNCape, lakeEffectSnowEvent_id: @bufkit.lakeEffectSnowEvent_id, lowDew: @bufkit.lowDew, lowHeight: @bufkit.lowHeight, lowHumidity: @bufkit.lowHumidity, lowTemp: @bufkit.lowTemp, lowWindDirection: @bufkit.lowWindDirection, lowWindSpeed: @bufkit.lowWindSpeed, medDew: @bufkit.medDew, medHeight: @bufkit.medHeight, medHumidity: @bufkit.medHumidity, medTemp: @bufkit.medTemp, medWindDirection: @bufkit.medWindDirection, medWindSpeed: @bufkit.medWindSpeed, modelCape: @bufkit.modelCape, modelType: @bufkit.modelType, tenMeterWindDirection: @bufkit.tenMeterWindDirection, tenMeterWindSpeed: @bufkit.tenMeterWindSpeed } }
    assert_redirected_to bufkit_url(@bufkit)
  end

  test "should destroy bufkit" do
    assert_difference("Bufkit.count", -1) do
      delete bufkit_url(@bufkit)
    end

    assert_redirected_to bufkits_url
  end
end

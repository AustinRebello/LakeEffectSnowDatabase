require "test_helper"

class LakeEffectSnowEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lake_effect_snow_event = lake_effect_snow_events(:one)
  end

  test "should get index" do
    get lake_effect_snow_events_url
    assert_response :success
  end

  test "should get new" do
    get new_lake_effect_snow_event_url
    assert_response :success
  end

  test "should create lake_effect_snow_event" do
    assert_difference("LakeEffectSnowEvent.count") do
      post lake_effect_snow_events_url, params: { lake_effect_snow_event: { averageLakeSurfaceTemperature: @lake_effect_snow_event.averageLakeSurfaceTemperature, endDate: @lake_effect_snow_event.endDate, endTime: @lake_effect_snow_event.endTime, eventName: @lake_effect_snow_event.eventName, peakEndTime: @lake_effect_snow_event.peakEndTime, peakStartTime: @lake_effect_snow_event.peakStartTime, startDate: @lake_effect_snow_event.startDate, startTime: @lake_effect_snow_event.startTime } }
    end

    assert_redirected_to lake_effect_snow_event_url(LakeEffectSnowEvent.last)
  end

  test "should show lake_effect_snow_event" do
    get lake_effect_snow_event_url(@lake_effect_snow_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_lake_effect_snow_event_url(@lake_effect_snow_event)
    assert_response :success
  end

  test "should update lake_effect_snow_event" do
    patch lake_effect_snow_event_url(@lake_effect_snow_event), params: { lake_effect_snow_event: { averageLakeSurfaceTemperature: @lake_effect_snow_event.averageLakeSurfaceTemperature, endDate: @lake_effect_snow_event.endDate, endTime: @lake_effect_snow_event.endTime, eventName: @lake_effect_snow_event.eventName, peakEndTime: @lake_effect_snow_event.peakEndTime, peakStartTime: @lake_effect_snow_event.peakStartTime, startDate: @lake_effect_snow_event.startDate, startTime: @lake_effect_snow_event.startTime } }
    assert_redirected_to lake_effect_snow_event_url(@lake_effect_snow_event)
  end

  test "should destroy lake_effect_snow_event" do
    assert_difference("LakeEffectSnowEvent.count", -1) do
      delete lake_effect_snow_event_url(@lake_effect_snow_event)
    end

    assert_redirected_to lake_effect_snow_events_url
  end
end

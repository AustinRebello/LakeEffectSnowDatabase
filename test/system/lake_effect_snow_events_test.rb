require "application_system_test_case"

class LakeEffectSnowEventsTest < ApplicationSystemTestCase
  setup do
    @lake_effect_snow_event = lake_effect_snow_events(:one)
  end

  test "visiting the index" do
    visit lake_effect_snow_events_url
    assert_selector "h1", text: "Lake effect snow events"
  end

  test "should create lake effect snow event" do
    visit lake_effect_snow_events_url
    click_on "New lake effect snow event"

    fill_in "Averagelakesurfacetemperature", with: @lake_effect_snow_event.averageLakeSurfaceTemperature
    fill_in "Enddate", with: @lake_effect_snow_event.endDate
    fill_in "Endtime", with: @lake_effect_snow_event.endTime
    fill_in "Eventname", with: @lake_effect_snow_event.eventName
    fill_in "Peakendtime", with: @lake_effect_snow_event.peakEndTime
    fill_in "Peakstarttime", with: @lake_effect_snow_event.peakStartTime
    fill_in "Startdate", with: @lake_effect_snow_event.startDate
    fill_in "Starttime", with: @lake_effect_snow_event.startTime
    click_on "Create Lake effect snow event"

    assert_text "Lake effect snow event was successfully created"
    click_on "Back"
  end

  test "should update Lake effect snow event" do
    visit lake_effect_snow_event_url(@lake_effect_snow_event)
    click_on "Edit this lake effect snow event", match: :first

    fill_in "Averagelakesurfacetemperature", with: @lake_effect_snow_event.averageLakeSurfaceTemperature
    fill_in "Enddate", with: @lake_effect_snow_event.endDate
    fill_in "Endtime", with: @lake_effect_snow_event.endTime
    fill_in "Eventname", with: @lake_effect_snow_event.eventName
    fill_in "Peakendtime", with: @lake_effect_snow_event.peakEndTime
    fill_in "Peakstarttime", with: @lake_effect_snow_event.peakStartTime
    fill_in "Startdate", with: @lake_effect_snow_event.startDate
    fill_in "Starttime", with: @lake_effect_snow_event.startTime
    click_on "Update Lake effect snow event"

    assert_text "Lake effect snow event was successfully updated"
    click_on "Back"
  end

  test "should destroy Lake effect snow event" do
    visit lake_effect_snow_event_url(@lake_effect_snow_event)
    click_on "Destroy this lake effect snow event", match: :first

    assert_text "Lake effect snow event was successfully destroyed"
  end
end

require "application_system_test_case"

class SnowReportsTest < ApplicationSystemTestCase
  setup do
    @snow_report = snow_reports(:one)
  end

  test "visiting the index" do
    visit snow_reports_url
    assert_selector "h1", text: "Snow reports"
  end

  test "should create snow report" do
    visit snow_reports_url
    click_on "New snow report"

    fill_in "City", with: @snow_report.city
    fill_in "Lakeeffectsnowevent", with: @snow_report.lakeEffectSnowEvent_id
    fill_in "Lastname", with: @snow_report.lastName
    fill_in "Latitude", with: @snow_report.latitude
    fill_in "Longitude", with: @snow_report.longitude
    fill_in "Stormtotal", with: @snow_report.stormTotal
    click_on "Create Snow report"

    assert_text "Snow report was successfully created"
    click_on "Back"
  end

  test "should update Snow report" do
    visit snow_report_url(@snow_report)
    click_on "Edit this snow report", match: :first

    fill_in "City", with: @snow_report.city
    fill_in "Lakeeffectsnowevent", with: @snow_report.lakeEffectSnowEvent_id
    fill_in "Lastname", with: @snow_report.lastName
    fill_in "Latitude", with: @snow_report.latitude
    fill_in "Longitude", with: @snow_report.longitude
    fill_in "Stormtotal", with: @snow_report.stormTotal
    click_on "Update Snow report"

    assert_text "Snow report was successfully updated"
    click_on "Back"
  end

  test "should destroy Snow report" do
    visit snow_report_url(@snow_report)
    click_on "Destroy this snow report", match: :first

    assert_text "Snow report was successfully destroyed"
  end
end

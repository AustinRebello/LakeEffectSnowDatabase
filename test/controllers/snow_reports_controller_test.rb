require "test_helper"

class SnowReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @snow_report = snow_reports(:one)
  end

  test "should get index" do
    get snow_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_snow_report_url
    assert_response :success
  end

  test "should create snow_report" do
    assert_difference("SnowReport.count") do
      post snow_reports_url, params: { snow_report: { city: @snow_report.city, lakeEffectSnowEvent_id: @snow_report.lakeEffectSnowEvent_id, lastName: @snow_report.lastName, latitude: @snow_report.latitude, longitude: @snow_report.longitude, stormTotal: @snow_report.stormTotal } }
    end

    assert_redirected_to snow_report_url(SnowReport.last)
  end

  test "should show snow_report" do
    get snow_report_url(@snow_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_snow_report_url(@snow_report)
    assert_response :success
  end

  test "should update snow_report" do
    patch snow_report_url(@snow_report), params: { snow_report: { city: @snow_report.city, lakeEffectSnowEvent_id: @snow_report.lakeEffectSnowEvent_id, lastName: @snow_report.lastName, latitude: @snow_report.latitude, longitude: @snow_report.longitude, stormTotal: @snow_report.stormTotal } }
    assert_redirected_to snow_report_url(@snow_report)
  end

  test "should destroy snow_report" do
    assert_difference("SnowReport.count", -1) do
      delete snow_report_url(@snow_report)
    end

    assert_redirected_to snow_reports_url
  end
end

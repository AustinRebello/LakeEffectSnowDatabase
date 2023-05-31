require "application_system_test_case"

class BufkitsTest < ApplicationSystemTestCase
  setup do
    @bufkit = bufkits(:one)
  end

  test "visiting the index" do
    visit bufkits_url
    assert_selector "h1", text: "Bufkits"
  end

  test "should create bufkit" do
    visit bufkits_url
    click_on "New bufkit"

    fill_in "Highdew", with: @bufkit.highDew
    fill_in "Highheight", with: @bufkit.highHeight
    fill_in "Highhumidity", with: @bufkit.highHumidity
    fill_in "Hightemp", with: @bufkit.highTemp
    fill_in "Highwinddirection", with: @bufkit.highWindDirection
    fill_in "Highwindspeed", with: @bufkit.highWindSpeed
    fill_in "Lakeeffectcape", with: @bufkit.lakeEffectCape
    fill_in "Lakeeffecteql", with: @bufkit.lakeEffectEQL
    fill_in "Lakeeffectncape", with: @bufkit.lakeEffectNCape
    fill_in "Lakeeffectsnowevent", with: @bufkit.lakeEffectSnowEvent_id
    fill_in "Lowdew", with: @bufkit.lowDew
    fill_in "Lowheight", with: @bufkit.lowHeight
    fill_in "Lowhumidity", with: @bufkit.lowHumidity
    fill_in "Lowtemp", with: @bufkit.lowTemp
    fill_in "Lowwinddirection", with: @bufkit.lowWindDirection
    fill_in "Lowwindspeed", with: @bufkit.lowWindSpeed
    fill_in "Meddew", with: @bufkit.medDew
    fill_in "Medheight", with: @bufkit.medHeight
    fill_in "Medhumidity", with: @bufkit.medHumidity
    fill_in "Medtemp", with: @bufkit.medTemp
    fill_in "Medwinddirection", with: @bufkit.medWindDirection
    fill_in "Medwindspeed", with: @bufkit.medWindSpeed
    fill_in "Modelcape", with: @bufkit.modelCape
    fill_in "Modeltype", with: @bufkit.modelType
    fill_in "Tenmeterwinddirection", with: @bufkit.tenMeterWindDirection
    fill_in "Tenmeterwindspeed", with: @bufkit.tenMeterWindSpeed
    click_on "Create Bufkit"

    assert_text "Bufkit was successfully created"
    click_on "Back"
  end

  test "should update Bufkit" do
    visit bufkit_url(@bufkit)
    click_on "Edit this bufkit", match: :first

    fill_in "Highdew", with: @bufkit.highDew
    fill_in "Highheight", with: @bufkit.highHeight
    fill_in "Highhumidity", with: @bufkit.highHumidity
    fill_in "Hightemp", with: @bufkit.highTemp
    fill_in "Highwinddirection", with: @bufkit.highWindDirection
    fill_in "Highwindspeed", with: @bufkit.highWindSpeed
    fill_in "Lakeeffectcape", with: @bufkit.lakeEffectCape
    fill_in "Lakeeffecteql", with: @bufkit.lakeEffectEQL
    fill_in "Lakeeffectncape", with: @bufkit.lakeEffectNCape
    fill_in "Lakeeffectsnowevent", with: @bufkit.lakeEffectSnowEvent_id
    fill_in "Lowdew", with: @bufkit.lowDew
    fill_in "Lowheight", with: @bufkit.lowHeight
    fill_in "Lowhumidity", with: @bufkit.lowHumidity
    fill_in "Lowtemp", with: @bufkit.lowTemp
    fill_in "Lowwinddirection", with: @bufkit.lowWindDirection
    fill_in "Lowwindspeed", with: @bufkit.lowWindSpeed
    fill_in "Meddew", with: @bufkit.medDew
    fill_in "Medheight", with: @bufkit.medHeight
    fill_in "Medhumidity", with: @bufkit.medHumidity
    fill_in "Medtemp", with: @bufkit.medTemp
    fill_in "Medwinddirection", with: @bufkit.medWindDirection
    fill_in "Medwindspeed", with: @bufkit.medWindSpeed
    fill_in "Modelcape", with: @bufkit.modelCape
    fill_in "Modeltype", with: @bufkit.modelType
    fill_in "Tenmeterwinddirection", with: @bufkit.tenMeterWindDirection
    fill_in "Tenmeterwindspeed", with: @bufkit.tenMeterWindSpeed
    click_on "Update Bufkit"

    assert_text "Bufkit was successfully updated"
    click_on "Back"
  end

  test "should destroy Bufkit" do
    visit bufkit_url(@bufkit)
    click_on "Destroy this bufkit", match: :first

    assert_text "Bufkit was successfully destroyed"
  end
end

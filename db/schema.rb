# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_31_181557) do
  create_table "bufkits", force: :cascade do |t|
    t.string "modelType"
    t.float "lowTemp"
    t.float "lowDew"
    t.integer "lowHumidity"
    t.integer "lowWindDirection"
    t.integer "lowWindSpeed"
    t.integer "lowHeight"
    t.float "medTemp"
    t.float "medDew"
    t.integer "medHumidity"
    t.integer "medWindDirection"
    t.integer "medWindSpeed"
    t.integer "medHeight"
    t.float "highTemp"
    t.float "highDew"
    t.integer "highHumidity"
    t.integer "highWindDirection"
    t.integer "highWindSpeed"
    t.integer "highHeight"
    t.integer "modelCape"
    t.integer "lakeEffectCape"
    t.integer "lakeEffectNCape"
    t.integer "lakeEffectEQL"
    t.integer "tenMeterWindDirection"
    t.integer "tenMeterWindSpeed"
    t.integer "lakeEffectSnowEvent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lakeEffectSnowEvent_id"], name: "index_bufkits_on_lakeEffectSnowEvent_id"
  end

  create_table "lake_effect_snow_events", force: :cascade do |t|
    t.string "eventName"
    t.date "startDate"
    t.date "endDate"
    t.integer "startTime"
    t.integer "endTime"
    t.integer "peakStartTime"
    t.integer "peakEndTime"
    t.integer "averageLakeSurfaceTemperature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metars", force: :cascade do |t|
    t.string "site"
    t.string "observationTime"
    t.float "temperature"
    t.float "dewPoint"
    t.float "humidity"
    t.integer "windDirection"
    t.integer "windSpeed"
    t.float "meanLevelSeaPressure"
    t.float "visibility"
    t.integer "windGust"
    t.string "presentWX"
    t.integer "peakWindGust"
    t.integer "peakWindDirection"
    t.string "peakWindTime"
    t.integer "lakeEffectSnowEvent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lakeEffectSnowEvent_id"], name: "index_metars_on_lakeEffectSnowEvent_id"
  end

  create_table "snow_reports", force: :cascade do |t|
    t.string "lastName"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.float "stormTotal"
    t.integer "lakeEffectSnowEvent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lakeEffectSnowEvent_id"], name: "index_snow_reports_on_lakeEffectSnowEvent_id"
  end

  add_foreign_key "bufkits", "lakeEffectSnowEvents"
  add_foreign_key "metars", "lakeEffectSnowEvents"
  add_foreign_key "snow_reports", "lakeEffectSnowEvents"
end

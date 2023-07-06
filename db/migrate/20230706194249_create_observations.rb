class CreateObservations < ActiveRecord::Migration[7.0]
  def change
    create_table :observations do |t|
      t.string :site
      t.string :date
      t.string :surPressure
      t.string :surTemperature
      t.string :surDewPoint
      t.string :surHumidity
      t.string :surWindDirection
      t.string :surWindSpeed
      t.string :surHeight
      t.string :ninePressure
      t.string :nineTemperature
      t.string :nineDewPoint
      t.string :nineHumidity
      t.string :nineWindDirection
      t.string :nineWindSpeed
      t.string :nineHeight
      t.string :eightPressure
      t.string :eightTemperature
      t.string :eightDewPoint
      t.string :eightHumidity
      t.string :eightWindDirection
      t.string :eightWindSpeed
      t.string :eightHeight
      t.string :sevenPressure
      t.string :sevenTemperature
      t.string :sevenDewPoint
      t.string :sevenHumidity
      t.string :sevenWindDirection
      t.string :sevenWindSpeed
      t.string :sevenHeight
      t.integer :lake_effect_snow_event_id

      t.timestamps
    end
  end
end

class CreateBufkits < ActiveRecord::Migration[7.0]
  def change
    create_table :bufkits do |t|
      t.string :modelType
      t.string :station
      t.string :date
      t.float :lowTemp
      t.float :lowDew
      t.float :lowHumidity
      t.float :lowHumidityIce
      t.integer :lowWindDirection
      t.integer :lowWindSpeed
      t.integer :lowHeight
      t.float :medTemp
      t.float :medDew
      t.float :medHumidity
      t.float :medHumidityIce
      t.integer :medWindDirection
      t.integer :medWindSpeed
      t.integer :medHeight
      t.float :highTemp
      t.float :highDew
      t.float :highHumidity
      t.float :highHumidityIce
      t.integer :highWindDirection
      t.integer :highWindSpeed
      t.integer :highHeight
      t.integer :modelCape
      t.integer :lakeEffectCape
      t.integer :lakeEffectNCape
      t.integer :lakeEffectEQL
      t.integer :tenMeterWindDirection
      t.integer :tenMeterWindSpeed
      t.float :bulkShear
      t.float :bulkShearU
      t.float :bulkShearV
      t.float :lowDeltaT
      t.float :highDeltaT
      t.boolean :maxOmega
      t.integer :lake_effect_snow_event_id

      t.timestamps
    end
  end
end

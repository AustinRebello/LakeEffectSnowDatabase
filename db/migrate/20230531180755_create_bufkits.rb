class CreateBufkits < ActiveRecord::Migration[7.0]
  def change
    create_table :bufkits do |t|
      t.string :modelType
      t.float :lowTemp
      t.float :lowDew
      t.integer :lowHumidity
      t.integer :lowWindDirection
      t.integer :lowWindSpeed
      t.integer :lowHeight
      t.float :medTemp
      t.float :medDew
      t.integer :medHumidity
      t.integer :medWindDirection
      t.integer :medWindSpeed
      t.integer :medHeight
      t.float :highTemp
      t.float :highDew
      t.integer :highHumidity
      t.integer :highWindDirection
      t.integer :highWindSpeed
      t.integer :highHeight
      t.integer :modelCape
      t.integer :lakeEffectCape
      t.integer :lakeEffectNCape
      t.integer :lakeEffectEQL
      t.integer :tenMeterWindDirection
      t.integer :tenMeterWindSpeed
      t.integer :lake_effect_snow_event_id

      t.timestamps
    end
  end
end

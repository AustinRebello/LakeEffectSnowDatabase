class CreateLakeEffectSnowEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :lake_effect_snow_events do |t|
      t.string :eventName
      t.date :startDate
      t.date :endDate
      t.date :peakStartDate
      t.date :peakEndDate
      t.integer :startTime
      t.integer :endTime
      t.integer :peakStartTime
      t.integer :peakEndTime
      t.integer :averageLakeSurfaceTemperature
      t.string :eventType
      t.string :tecOne
      t.string :tecTwo
      t.string :tecThree
      t.string :tecFour
      t.integer :tecYearOne
      t.integer :tecYearTwo
      t.integer :tecYearThree
      t.integer :tecYearFour


      t.timestamps
    end
  end
end

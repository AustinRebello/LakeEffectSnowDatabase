class CreateMetars < ActiveRecord::Migration[7.0]
  def change
    create_table :metars do |t|
      t.string :site
      t.string :observationTime
      t.float :temperature
      t.float :dewPoint
      t.float :humidity
      t.integer :windDirection
      t.integer :windSpeed
      t.float :meanLevelSeaPressure
      t.float :visibility
      t.integer :windGust
      t.string :presentWX
      t.integer :peakWindGust
      t.integer :peakWindDirection
      t.string :peakWindTime
      t.references :lakeEffectSnowEvent, null: false, foreign_key: true

      t.timestamps
    end
  end
end

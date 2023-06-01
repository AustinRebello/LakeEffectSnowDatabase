class CreateSnowReports < ActiveRecord::Migration[7.0]
  def change
    create_table :snow_reports do |t|
      t.string :lastName
      t.string :city
      t.float :latitude
      t.float :longitude
      t.float :stormTotal
      t.integer :lake_effect_snow_event_id

      t.timestamps
    end
  end
end

class CreateStops < ActiveRecord::Migration
  def self.up
    create_table :stops do |t|
      t.integer :journey_id
      t.string :code
      t.string :bay_number
      t.string :timing_point
      t.string :fare_stage
      t.integer :arrival_time
      t.integer :departure_time
      t.integer :bus_stop_id
      t.timestamps
    end
  end

  def self.down
    drop_table :stops
  end
end

class CreateZLocations < ActiveRecord::Migration
  def self.up
    create_table :z_locations do |t|
      t.string :code
      t.string :name
      t.integer :route_id
      t.integer :bus_stop_id
      t.timestamps
    end
  end

  def self.down
    drop_table :z_locations
  end
end

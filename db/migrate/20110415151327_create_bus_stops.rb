class CreateBusStops < ActiveRecord::Migration
  def self.up
    create_table :bus_stops  do |t|
      t.string  :name
      t.string  :code
      t.string  :latitude
      t.string  :longitude
      t.string  :easting
      t.string  :northing
      t.string  :locality
      t.string  :parent_locality
      t.string  :bearing
      t.timestamps
    end
  end

  def self.down
    drop_table :bus_stops
  end
end

class ChangeLatLonEastNorthToNumbersInBusStops < ActiveRecord::Migration
  def self.up
    change_column :bus_stops, :latitude, :float
    change_column :bus_stops, :longitude, :float
    change_column :bus_stops, :easting, :integer
    change_column :bus_stops, :northing, :integer
  end

  def self.down
    change_column :bus_stops, :latitude, :string
    change_column :bus_stops, :longitude, :string
    change_column :bus_stops, :easting, :string
    change_column :bus_stops, :northing, :string
  end
end

class ChangeLatLonToDoubleInBusStops < ActiveRecord::Migration
  def self.up
    change_column :bus_stops, :latitude, :double
    change_column :bus_stops, :longitude, :double
  end

  def self.down
    change_column :bus_stops, :latitude, :float
    change_column :bus_stops, :longitude, :float
  end
end

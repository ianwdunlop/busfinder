class ChangeLatLonToDecimalInBusStops < ActiveRecord::Migration
  def self.up
    change_column :bus_stops, :latitude, :decimal
    change_column :bus_stops, :longitude, :decimal
  end

  def self.down
    change_column :bus_stops, :latitude, :double
    change_column :bus_stops, :longitude, :double
  end
end

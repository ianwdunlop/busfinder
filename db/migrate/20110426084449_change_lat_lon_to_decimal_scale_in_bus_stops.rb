class ChangeLatLonToDecimalScaleInBusStops < ActiveRecord::Migration
  def self.up
    change_column :bus_stops, :latitude, :decimal, :precision=>15, :scale=>10
    change_column :bus_stops, :longitude, :decimal, :precision=>15, :scale=>10
  end

  def self.down
    change_column :bus_stops, :latitude, :double
    change_column :bus_stops, :longitude, :double
  end
end

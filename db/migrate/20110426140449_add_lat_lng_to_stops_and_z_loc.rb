class AddLatLngToStopsAndZLoc < ActiveRecord::Migration
  def self.up
    add_column :stops, :latitude, :decimal, :precision=>15, :scale=>10
    add_column :stops, :longitude, :decimal, :precision=>15, :scale=>10
    add_column :z_locations, :latitude, :decimal, :precision=>15, :scale=>10
    add_column :z_locations, :longitude, :decimal, :precision=>15, :scale=>10
  end

  def self.down
    remove_column :stops, :latitude
    remove_column :stops, :longitude
    remove_column :z_locations, :latitude
    remove_column :z_locations, :latitude
  end
end

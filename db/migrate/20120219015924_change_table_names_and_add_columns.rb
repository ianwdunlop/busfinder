class ChangeTableNamesAndAddColumns < ActiveRecord::Migration
  def change
    rename_column :journeys, :route_id, :bus_route_id
    rename_column :bus_stop_routes, :route_id, :bus_route_id
    rename_column :stops, :journey_id, :bus_journey_id
    rename_column :z_locations, :route_id, :bus_route_id
    rename_table :journeys, :bus_journeys
    rename_table :routes, :bus_routes
  end
end

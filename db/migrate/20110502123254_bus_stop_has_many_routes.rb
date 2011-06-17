class BusStopHasManyRoutes < ActiveRecord::Migration
  def self.up
    create_table :bus_stop_routes do |t|
      t.integer :route_id
      t.integer :bus_stop_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bus_stop_routes
  end
end

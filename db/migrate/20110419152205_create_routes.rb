class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.string :route_number
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :routes
  end
end

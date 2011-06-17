class CreateJourneys < ActiveRecord::Migration
  def self.up
    create_table :journeys do |t|
    t.string :vehicle_type
    t.string :registration_number
    t.string :identifier
    t.string :operator
    t.string :route_number
    t.string :first_date_of_operation
    t.string :running_board
    t.string :last_date_of_operation
    t.string :school_term_time
    t.string :route_direction
    t.string :bank_holidays
    t.integer :route_id
    t.boolean :mondays
    t.boolean :tuesdays
    t.boolean :wednesdays
    t.boolean :thursdays
    t.boolean :fridays
    t.boolean :saturdays
    t.boolean :sundays
    t.timestamps
    end
  end

  def self.down
    drop_table :journeys
  end
end

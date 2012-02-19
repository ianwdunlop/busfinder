# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120219015924) do

  create_table "bus_journeys", :force => true do |t|
    t.string   "vehicle_type"
    t.string   "registration_number"
    t.string   "identifier"
    t.string   "operator"
    t.string   "route_number"
    t.string   "first_date_of_operation"
    t.string   "running_board"
    t.string   "last_date_of_operation"
    t.string   "school_term_time"
    t.string   "route_direction"
    t.string   "bank_holidays"
    t.integer  "bus_route_id"
    t.boolean  "mondays"
    t.boolean  "tuesdays"
    t.boolean  "wednesdays"
    t.boolean  "thursdays"
    t.boolean  "fridays"
    t.boolean  "saturdays"
    t.boolean  "sundays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bus_routes", :force => true do |t|
    t.string   "route_number"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bus_stop_routes", :force => true do |t|
    t.integer  "bus_route_id"
    t.integer  "bus_stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bus_stops", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "latitude",        :precision => 15, :scale => 10
    t.decimal  "longitude",       :precision => 15, :scale => 10
    t.integer  "easting"
    t.integer  "northing"
    t.string   "locality"
    t.string   "parent_locality"
    t.string   "bearing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stops", :force => true do |t|
    t.integer  "bus_journey_id"
    t.string   "code"
    t.string   "bay_number"
    t.string   "timing_point"
    t.string   "fare_stage"
    t.integer  "arrival_time"
    t.integer  "departure_time"
    t.integer  "bus_stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",       :precision => 15, :scale => 10
    t.decimal  "longitude",      :precision => 15, :scale => 10
  end

  create_table "z_locations", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "bus_route_id"
    t.integer  "bus_stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",     :precision => 15, :scale => 10
    t.decimal  "longitude",    :precision => 15, :scale => 10
  end

end

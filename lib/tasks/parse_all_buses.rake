require 'rubygems'
require 'rake'
require 'active_record/fixtures'
require 'nokogiri'
require 'atco'

namespace :busfinder do
  desc "load bus data from cif files and cross ref with the bus top lat/lng data"
  task :parse_bus_data  => :environment do
    dir_path = '/Users/Ian/scratch/bus_routes/'
    # dir_path = '/Users/Ian/Downloads/GMPTE_CIF/'
    files = Dir.entries(dir_path)
    files.each do |file|
      begin
      atco_file = File.join(dir_path, file)
      puts "parsing " + atco_file
      parser = Atco::Parser.new
      result = parser.parse(atco_file)
    g = result[:gmpte_info]
    # r = result[:journeys]
    g.each do |z_journey|
      #eg 00000001, 000000002 cross ref with the journey key
       journey_identifiers = z_journey.journey_identifiers
       #eg sundays
       days_of_the_week = z_journey.days_of_the_week_text
       #eg 108
       route_name = z_journey.journey_route.route_name
       #eg STOCKPORT - MACCLESFIELD - LEEK
       route_text = z_journey.journey_route.route_text
      # puts "journey " + journey_identifiers.to_s + " " + days_of_the_week + " " + route_name + " " + route_text
      
      puts "finding route " + route_name + " " + route_text
      route = Route.where(:route_number=>route_name, :description => route_text).first
      if route == nil
        route = Route.new(:route_number => route_name, :description => route_text)
        route.save
        #new route save save the stops
         z_journey.z_locations.each do |z_location|
                  #create bus stop location
                  name = z_location.name
                  code = z_location.identifier
                  z_location = ZLocation.new(:name => name, :code => code.strip, :route => route)
                  z_location.save
                  bus_stops = BusStop.where(:code=>z_location.code.strip)
                  if !bus_stops.empty?
                    bsr = BusStopRoute.new(:route=>z_location.route, :bus_stop =>bus_stops.first)
                    bsr.save
                  end
                end
      end

     
            
              z_journey.journeys.each do |journey|
                #the key is the cross reference for the journeys
                # journey = r[key]
            #    puts "*******new journey********"
                j = Journey.new(:identifier => journey.identifier, :vehicle_type=>journey.vehicle_type, :operator =>journey.operator,
                :route_number=>journey.route_number, :route_direction=>journey.route_direction,
                :first_date_of_operation=>journey.first_date_of_operation, :last_date_of_operation=>journey.last_date_of_operation,
                :running_board=>journey.running_board, :school_term_time=>journey.school_term_time,
                :bank_holidays=>journey.bank_holidays, :route=>route, :mondays => journey.mondays?, :tuesdays => journey.tuesdays?,
                :wednesdays => journey.wednesdays?, :thursdays => journey.thursdays?, :fridays => journey.fridays?, :saturdays => journey.saturdays?,
                :sundays => journey.sundays?)
                j.save

                journey.stops.each do |stop|
              #    puts "doing journey"
                  #create stop
                  if stop.location != nil
                     # puts "stop is " + stop.location
                      bus_stop = BusStop.where(:code => stop.location.strip).first
                      s = Stop.new(:journey => j, :code=>stop.location.strip, :bay_number=>stop.bay_number, :timing_point=>stop.timing_point_indicator,
                      :fare_stage=>stop.fare_stage_indicator, :arrival_time=>stop.published_arrival_time.to_i, :departure_time=>stop.published_departure_time.to_i)
                      if bus_stop == nil
                        zloc = ZLocation.where(:code=>stop.location.strip).first
                        if zloc
                          bus_stop_text = zloc.name
                        else
                          bus_stop_text = nil
                        end
                        bus_stop = BusStop.new(:name=>bus_stop_text, :code=>stop.location.strip)
                        bus_stop.save
                      end
                      s = Stop.new(:journey => j, :code=>stop.location.strip, :bay_number=>stop.bay_number, :timing_point=>stop.timing_point_indicator,
                      :fare_stage=>stop.fare_stage_indicator, :arrival_time=>stop.published_arrival_time.to_i, :departure_time=>stop.published_departure_time.to_i, :bus_stop=>bus_stop)
                      s.save
                  end
                end
    end
    end
  rescue Exception => e
    puts e
  end
  end
  end
end
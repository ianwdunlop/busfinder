require 'rubygems'
require 'rake'
require 'active_record/fixtures'
require 'nokogiri'
require 'atco'

namespace :busfinder do
  desc "load bus data from cif files and cross ref with the bus top lat/lng data"
  task :parse_single_bus  => :environment do
    dir_path = '/Users/Ian/Downloads/GMPTE_CIF/'
    # dir_path = '/Users/Ian/scratch/'
    # file = 'GMF_225_conv.CIF'
    # file = 'GMF_225_.CIF'
    file = 'GMA_108_.CIF'
      # begin
      atco_file_path = File.join(dir_path, file)
      atco_file = File.open(atco_file_path, "r:iso-8859-1:utf-8")
      puts "parsing " + atco_file_path
    parser = Atco::Parser.new
    result = parser.parse(atco_file)
    g = result[:gmpte_info]
    r = result[:journeys]
    route_array = []
    g.each do |journey|
      #eg 00000001, 000000002 cross ref with the journey key
       journey_identifiers = journey.journey_identifiers
       #eg sundays
       days_of_the_week = journey.days_of_the_week_text
       #eg 108
       route_name = journey.journey_route.route_name
       #eg STOCKPORT - MACCLESFIELD - LEEK
       route_text = journey.journey_route.route_text
      puts "journey " + journey_identifiers.to_s + " " + days_of_the_week + " " + route_name + " " + route_text
      route = Route.new(:route_number => route_name, :description => route_text, :days_of_the_week => days_of_the_week)
      route_array << route
      journey.z_locations.each do |z_location|
 
        #create bus stop location
        name = z_location.name
        code = z_location.identifier
        z_location = ZLocation.new(:name => name, :code => code.strip)
        bus_stops = BusStop.where(:code => code.strip)
         puts bus_stops.size.to_s
       puts "z loc " + z_location.name.to_s + " " + z_location.code.to_s
       if !bus_stops.empty?
         puts "should be a stop"
         z_location.bus_stop = bus_stops.first
       end
        # z_location.save unless !ZLocation.all(:conditions => {:code=>code}).empty?
        #get lat lon from the xml rdf file based on the name
      end
    end
    r.each do |journey|
      #the key is the cross reference for the journeys
      # journey = r[key]
     puts "*******new journey********"
      j = Journey.new(:identifier => journey.identifier, :vehicle_type=>journey.vehicle_type, :operator =>journey.operator,
                :route_number=>journey.route_number, :route_direction=>journey.route_direction,
                :first_date_of_operation=>journey.first_date_of_operation, :last_date_of_operation=>journey.last_date_of_operation,
                :running_board=>journey.running_board, :school_term_time=>journey.school_term_time,
                :bank_holidays=>journey.bank_holidays)
      # j.save
      
      puts j.vehicle_type + " " + j.operator + " " + j.route_number + " " + j.route_direction + " " + j.first_date_of_operation +
         " " + j.last_date_of_operation + " " + j.running_board + " " + j.school_term_time + " " + j.bank_holidays
      
      journey.stops.each do |stop|
       puts "doing journey"
        #create stop
        if stop.location != nil
           puts "stop is " + stop.location.strip + "stop"
           bus_stops = BusStop.where(:code => stop.location.strip)
           puts bus_stops.size.to_s
            s = Stop.new(:journey => j, :code=>stop.location.strip, :bay_number=>stop.bay_number, :timing_point=>stop.timing_point_indicator,
            :fare_stage=>stop.fare_stage_indicator, :arrival_time=>stop.published_arrival_time.to_i, :departure_time=>stop.published_departure_time.to_i)
            if !bus_stops.empty?
              puts "should be a stop"
              s.bus_stop = bus_stops.first
              puts s.bus_stop.code
            end
            # s.save
        else
          #no point saving empty stop
      #    puts "stop location is nil"
          # s = Stop.new(:journey => j, :bay_number=>stop.bay_number, :timing_point=>stop.timing_point_indicator,
          # :fare_stage=>stop.fare_stage_indicator, :time=>stop.published_departure_time)
          # s.save
        end
      end
    end
  # rescue Exception => e
  #    puts e
  #  end
  end
end
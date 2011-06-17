require 'rubygems'
require 'rake'
require 'active_record/fixtures'
require 'nokogiri'
require 'atco'

namespace :busfinder do
  desc "load bus data from rdf xml file and load into db"
  task :add_locations_to_stops  => :environment do
    # Stop.all.each do |stop|
    #   bus_stops = BusStop.where(:code=>stop.code)
    #   if !bus_stops.empty?
    #     puts "stop " + stop.id.to_s + " " + stop.code
    #     stop.latitude = bus_stops.first.latitude
    #     stop.longitude = bus_stops.first.longitude
    #     stop.save
    #   end 
    # end
    ZLocation.all.each do |z_location|
      bus_stops = BusStop.where(:code=>z_location.code)
      if !bus_stops.empty?
        puts "zloc " + z_location.id.to_s + " " + z_location.code
        z_location.latitude = bus_stops.first.latitude
        z_location.longitude = bus_stops.first.longitude
        z_location.save
      end 
    end
  end
end
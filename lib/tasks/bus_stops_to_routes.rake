require 'rubygems'
require 'rake'
require 'active_record/fixtures'
require 'nokogiri'
require 'atco'

namespace :busfinder do
  desc "add bus stops to routes"
  task :add_bus_stops_to_routes  => :environment do
    ZLocation.all.each do |z_location|
      bus_stops = BusStop.where(:code=>z_location.code.strip)
      if !bus_stops.empty?
        puts "bus stop: " + bus_stops.first.id.to_s + ",route: " + z_location.route.id.to_s
        bsr = BusStopRoute.new(:route=>z_location.route, :bus_stop =>bus_stops.first)
        bsr.save
      end 
    end
  end
end
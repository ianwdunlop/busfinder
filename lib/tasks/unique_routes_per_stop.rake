require 'rubygems'
require 'rake'
require 'active_record/fixtures'
require 'nokogiri'
require 'atco'

namespace :busfinder do
  desc "figure out the unique routes per stop"
  task :unique_routes_per_stop  => :environment do
    ZLocation.all.each do |z_location|
      bus_stops = BusStop.where(:code=>z_location.code.strip)
      if !bus_stops.empty?
        if BusStopRoute.where(:route => z_location.route.route_number.strip).empty?
          puts "bus stop: " + bus_stops.first.id.to_s + ",route: " + z_location.route.id.to_s
          bsr = BusStopRoute.new(:route=>z_location.route.route_number.strip, :bus_stop =>bus_stops.first,:description => z_location.route.description)
          bsr.save
        end
      end 
    end
  end
end
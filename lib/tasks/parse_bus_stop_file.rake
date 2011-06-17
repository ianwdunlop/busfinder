require 'rubygems'
require 'rake'
require 'active_record/fixtures'
require 'nokogiri'
require 'csv'

namespace :busfinder do
  desc "load bus data from rdf xml file and load into db"
  task :parse_bus_stops  => :environment do
    # file = File.open('/Users/Ian/Documents/manchester_bus_stops.xml','r')
    #     doc = Nokogiri::XML(file)
    #     nodes = doc.xpath('//rdf:Description')
    #     nodes.each do |node|
    #       code =  node.first[1].split('/').last
    #       easting = node.xpath('./spatial:easting')[0].content
    #       northing = node.xpath('./spatial:northing')[0].content
    #       longitude = node.xpath('./geo:long')[0].content
    #       latitude = node.xpath('./geo:lat')[0].content
    #       name =  node.xpath('./skos:prefLabel')[0].content
    #       puts "processing stop: " + name + ": " + code
    #       stop = BusStop.new(:name => name, :code => code, :easting => easting, :northing => northing, :latitude => latitude, :longitude => longitude)
    #       stop.save
    #     end
    file = CSV.open(File.open('/Users/Ian/Downloads/NaPTANcsv/Stops.csv'),:headers=>true)
    file.each do |line|
      stop = BusStop.new(:bearing => line.field('Bearing'), :locality => line.field('LocalityName'), :parent_locality => line.field('ParentLocalityName'), :name => line.field('Street'), :code =>  line.field('AtcoCode'), :easting => line.field('Easting'), :northing => line.field('Northing'), :latitude => line.field('Latitude'), :longitude => line.field('Longitude'))
      stop.save
    end
  end
end

#Busfinder - UK bus stop and route information
#Copyright (C) 2011  Ian Dunlop

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

class BusStopsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  def show
    @bus_stop = BusStop.find(params[:id])  
  end
  
  #Calculate the bus stops that appear in a bounding box and send back to client.
  #If the area requested is greater than 3km then do nothing
  def by_bounds
    distance = distance_between(params[:northeast_lat], params[:southwest_lat], params[:northeast_lon], params[:southwest_lon])
    if distance < 3
      sw = GeoKit::LatLng.new(params[:southwest_lat], params[:southwest_lon])
      ne = GeoKit::LatLng.new(params[:northeast_lat], params[:northeast_lon])
      @bus_stops = BusStop.joins(:bus_routes).where(:bus_routes != nil).geo_scope(:bounds => [sw,ne])
    
      respond_with @bus_stops
      #should be an else that sends a helpful message like 'distance too big'
    end
  end
  
  #Calculate all the bus stops within a certain range of a starting point as long as
  #it is less than 3km
  def by_range
    if params[:distance] < 3
      @bus_stops = BusStop.within(params[:distance], :origin=>[params[:latitude], params[:longitude]])
      respond_with @bus_stops
    end
  end
  
  # given a stop and a location, pick the possible routes, rank
  # them in terms of time and also give the timing information
  def route_between_stop_and_location
    
  end
  
  # given a start and end stop, pick the possible routes and rank in terms of
  # journey times
  def route_between_two_stops
  end
  
end
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

class JourneysController < ApplicationController
  
  respond_to :html, :xml, :json
  
  before_filter :find_journey, :only => [:show]
  before_filter :find_journeys, :only => [:index]
  
  # no need for these, all geo stuff handled by bus stops
  # journeys inside a square bounded by southwest lat/lon and northeast lat/lon
  # def by_bounds
  #   #TODO a more active record way of doing this - there seems to be one but the syntax is odd
  #   join_string = "INNER JOIN stops ON journeys.id = stops.id"
  #   query_string = "stops.latitude between ? and ? and stops.longitude between ? and ?"
  #   @journeys = Journey.joins(join_string).where(query_string, params[:southwest_lat], params[:northeast_lat], :params[:southwest_lon], :params[:northeast_lon])
  #   respond_with @journeys
  # end
  # 
  # def by_range
  #   params[:latitude]
  #   params[:latitude]
  #   params[:distance]
  #   stops = Stop.within(params[:distance], :origin=>[params[:latitude], params[:longitude]])
  #   #TODO get unique journeys
  # end

  def index
    respond_with @journeys
  end

  def show
    respond_with @journey
  end
  
  protected
  
  private
  
  def find_journey
    @journey = Journey.find(params[:id])
  end
  
  def find_journeys
    @journeys = Journey.all
  end

end
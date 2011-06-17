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

class RoutesController < ApplicationController
  
    respond_to :html, :xml, :json
    
    # all geo stuff handled by bus stops
  # def by_bounds
  #   join_string = "INNER JOIN z_locations ON routes.id = z_locations.id"
  #   query_string = "z_locations.latitude between ? and ? and z_locations.longitude between ? and ?"
  #   @routes = Route.joins(join_string).where(query_string, params[:southwest_lat], params[:northeast_lat], :params[:southwest_lon], :params[:northeast_lon])
  #   respond_with @routes
  # end
  
  def show
    @route = Route.find(params[:id])
    puts @route.to_json(:include => :bus_stops)
    respond_with @route
  end
  
  def index
  end
  
end
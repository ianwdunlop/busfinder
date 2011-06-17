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

class BusStop < ActiveRecord::Base
  acts_as_mappable  :lat_column_name => :latitude,
                    :lng_column_name => :longitude
  has_many :bus_stop_routes
  has_many :routes, :through => :bus_stop_routes
end
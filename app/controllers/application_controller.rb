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

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def degrees_to_radians(deg)
    radians = deg*(Math::PI/180)
    return radians
 end

  def distance_between(lat1, lat2, lon1, lon2)

  	r = 6371  #km
  	dLat = degrees_to_radians(lat2.to_f - lat1.to_f)
  	dLon = degrees_to_radians(lon2.to_f - lon1.to_f)
  	lat_one = degrees_to_radians(lat1.to_f)
    lat_two = degrees_to_radians(lat2.to_f)

  	a = Math.sin(dLat/2) * Math.sin(dLat/2) +
  	        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat_one) * Math.cos(lat_two)
  	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  	d = r * c
  	return d
  end
  
end

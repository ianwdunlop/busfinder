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

class WelcomeController < ApplicationController
  
  layout 'application'
  
  def json
    @stuff = "{'x':'a','y':'b'}".to_json
    respond_to do |format|
        format.json { render :json => @stuff }
    end
  end
  
  def index
  end
end